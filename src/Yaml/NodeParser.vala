/* NodeParser.vala
 * 
 * Copyright (C) 2012 nuhrin
 * 
 * This file is part of catapult.
 * 
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *      nuhrin <nuhrin@oceanic.to>
 */
 
using Gee;

namespace Catapult.Yaml
{
	public class NodeParser
	{
		DataInterface data_interface;
		public NodeParser() { }
		internal NodeParser.with_data_interface(DataInterface data_interface) {
			this.data_interface = data_interface;
		}

		public T parse<T>(Node node, T default_value) {
			Value? inval = null;
			if (default_value != null)
				inval = ValueHelper.populate_value<T>(default_value);
			Value v = ParseValue(node, typeof(T), inval);
			return ValueHelper.extract_value<T>(v);
		}
		public Value parse_value(Node node, Value? default_value=null) {
			return (default_value == null)
				? ParseValue(node)
				: ParseValue(node, null, default_value);
		}
		public Value parse_value_of_type(Node node, Type type, Value? default_value=null) { return ParseValue(node, type, default_value); }
		public bool parse_map_item<K,V>(MappingNode mapping, Node key_node, out K key, out V value) {
			if (mapping.has_key(key_node) == true) {
				Value keyValue = ParseValueSupportingEntityReference(key_node, typeof(K), null, false);
				Value valueValue = ParseValueSupportingEntityReference(mapping[key_node], typeof(V), null, false);
				if (keyValue.holds(typeof(K)) && valueValue.holds(typeof(V))) {
					key = ValueHelper.extract_value<K>(keyValue);
					value = ValueHelper.extract_value<V>(valueValue);
					return true;
				}				
			}
			key = null;
			value = null;
			return false;
		}
		
		public void populate_object_properties_from_mapping(Object obj, MappingNode? mapping) {
			if (mapping == null)
				return;
			PopulateObjectProperties(obj, mapping);
		}
		public void populate_map_from_mapping(Map map, MappingNode? mapping) {
			if (mapping == null)
				return;
			map.clear();
			var key_type = map.key_type;
			var	value_type = map.value_type;				
			var indirect_map = IndirectGenericsHelper.Gee.Map.indirect(map);
			foreach(var keyNode in mapping.keys()) {
				var valueNode = mapping[keyNode];
				Value key = ParseValueSupportingEntityReference(keyNode, key_type);
				Value value = ParseValueSupportingEntityReference(valueNode, value_type);
				if (key.holds(key_type) && value.holds(value_type))
					indirect_map.set(map, key, value);
			}
		}
		public void populate_collection_from_sequence(Collection collection, SequenceNode? sequence) {
			if (sequence == null)
				return;			
			collection.clear();
			var indirect_collection = IndirectGenericsHelper.Gee.Collection.indirect(collection);
			Type element_type = collection.element_type;
			foreach(var item in sequence.items()) {
				Value element = ParseValueSupportingEntityReference(item, element_type);
				if (element.holds(element_type))
					indirect_collection.add(collection, element);
			}
		}
		public void populate_enumerable_from_sequence(Enumerable enumerable, SequenceNode? sequence) {
			var indirect = IndirectGenericsHelper.Enumerable.indirect(enumerable);
			Collection collection = indirect.create_collection_obj();
			populate_collection_from_sequence(collection, sequence);
			indirect.change_basis(enumerable, collection);
		}
		
		public bool set_object_property(Object obj, string property_name, Node value_node) {
			var property = ((ObjectClass)obj.get_type().class_peek()).find_property(property_name);
			return PopulateObjectProperty(obj, property_name, property, value_node);
		}
		public bool set_object_property_from_mapping(Object obj, string property_name, MappingNode mapping) {
			var value_node = mapping.get_scalar(property_name);
			if (value_node == null)
				return false;
			return set_object_property(obj, property_name, value_node);
		}
		

		Value ParseValue(Node node, Type? type=null, Value? default_value=null, bool use_default_for_scalar=true) {
			Type? intype = type;
			Object invalObj = null;
			if (default_value != null)
			{
				if (default_value.holds(typeof(Object)))
					invalObj = default_value.get_object();
				intype = (invalObj != null) ? invalObj.get_type() : default_value.type();
			}
			if (intype != null && intype.is_a(typeof(IYamlObject))) {
				IYamlObject yamlObj = (invalObj == null)
					? Object.new(intype) as IYamlObject
					: (IYamlObject)invalObj;
				yamlObj.i_apply_yaml_node(node, this);
				Value val = Value(intype);
				val.set_object(yamlObj);
				return val;
			}

			switch(node.node_type)
			{
				case NodeType.SCALAR:
					return ParseScalar(node as ScalarNode, intype, default_value, use_default_for_scalar);
				case NodeType.MAPPING:
					return ParseMapping(node as MappingNode, intype, default_value);
				case NodeType.SEQUENCE:
					return ParseSequence(node as SequenceNode, intype, default_value);
				default:
					break;
			}
			return default_value;
		}

		Value ParseScalar(ScalarNode scalar, Type? type=null, Value? default_value=null, bool use_default=true) {
			Type t;
			if (type == null) {
				Type? tag_type = get_tag_type(scalar.tag);
				t = (tag_type == null) ? typeof(string) : tag_type;
			} else {
				t = type;
			}

			Value v = Value(t);
			if (scalar.tag == YAML.NULL_TAG)
				return v;
			if (t.is_flags()) {
				unowned GLibPatch.FlagsValue? flags_value = ((GLibPatch.FlagsClass)t.class_ref()).get_value_by_nick(scalar.value);
				if (flags_value != null)
					v.set_flags(flags_value.value);
			}
			else if (t.is_enum()) {
				var enum_value = ((EnumClass)type.class_ref()).get_value_by_nick(scalar.value);
				if (enum_value != null)
					v.set_enum(enum_value.value);
			}
			else if (t == typeof(string))
				v.set_string(scalar.value);
			else if (t == typeof(int))
				v.set_int(int.parse(scalar.value));
			else if (t == typeof(uint))
				v.set_uint((uint)int.parse(scalar.value));
			else if (t == typeof(bool))
				v.set_boolean(bool.parse(scalar.value));
			else if (t == typeof(double))
				v.set_double(double.parse(scalar.value));
			else if (t == typeof(Date))
			{
				Date d = Date();
				d.set_parse(scalar.value);
				if (d.valid() == false) {
					warning("Could not parse GDate from '%s'", scalar.value);
					d = Date();
					d.set_time_t(0);
				}
				v = d;
			}
			else
				return (use_default) ? default_value : Value(typeof(Fail));

			return v;
		}
		class Fail {}

		Value ParseMapping(MappingNode mapping, Type? type=null, Value? default_value=null) {
			Type t;
			if (default_value != null) {
				t = default_value.type();
			} else if (type != null) {
				t = type;
			} else {
				Type? tag_type = get_tag_type(mapping.tag);
				t = (tag_type == null) ? typeof(HashMap) : tag_type;
			}

			Value v = Value(t);

			if (t.is_a(typeof(Map))) {
				Map map = (default_value != null) ? (Map)default_value.get_object() : null;
				if (map == null) {
					warning("No instance of generic type %s given. Element type cannot be determined without an instance.", t.name());
					assert_not_reached();
				}
				map.clear();
				populate_map_from_mapping(map, mapping);
				v.set_object(map);
			} else if (t.is_object()) {
				Object obj = (default_value == null)
					? Object.new(t)
					: default_value.get_object();
				PopulateObjectProperties(obj, mapping);
				v.set_object(obj);
			} else {
				warning("Unsupported mapping type: %s", t.name());
				assert_not_reached();
			}

			return v;
		}
		void PopulateObjectProperties(Object obj, MappingNode mapping) {
			Type type = obj.get_type();
			foreach(var keyNode in mapping.scalar_keys()) {
				var property = ((ObjectClass)type.class_peek()).find_property(keyNode.value);
				PopulateObjectProperty(obj, keyNode.value, property, mapping[keyNode]);
			}
		}
		bool PopulateObjectProperty(Object obj, string property_name, ParamSpec? property, Node value_node) {
			if (property == null) {
				warning("Parse error: property '%s' not found on type %s", property_name, obj.get_type().name());
				return false;
			}
			if ((property.flags & ParamFlags.READWRITE) == ParamFlags.READWRITE) {
				Value existing_prop_value = Value(property.value_type);
				obj.get_property(property.name, ref existing_prop_value);
				Value new_prop_value = ParseValueSupportingEntityReference(value_node, property.value_type, existing_prop_value, false);
				if (new_prop_value.holds(property.value_type) == false && obj != null) {
					bool parsed = false;
					var yobj = obj as IYamlObject;
					if (yobj != null) {
						parsed = yobj.i_apply_unhandled_value_node(value_node, property.name, this);
					}
					if (parsed == false) {
						warning("Parse error: failed to parse property '%s' on type %s", property_name, obj.get_type().name());
						return false;
					}
				} else {
					obj.set_property(property.name, new_prop_value);
				}
				return true;
			}
			return false;
		}
		
		Value ParseSequence(SequenceNode sequence, Type? type=null, Value? default_value=null) {
			Type t;
			if (default_value != null) {
				t = default_value.type();
			} else if (type != null) {
				t = type;
			} else {
				Type? tag_type = get_tag_type(sequence.tag);
				t = (tag_type == null) ? typeof(ArrayList) : tag_type;
			}

			Value v = Value(t);

			if (t.is_a(typeof(Enumerable))) {
				Enumerable enumerable = (default_value != null) ? (Enumerable)default_value.get_object() : null;
				if (enumerable == null) {
					warning("No instance of generic type %s given. Element type cannot be determined without an instance.", t.name());
					assert_not_reached();
				}
				populate_enumerable_from_sequence(enumerable, sequence);
				v.set_object(enumerable);
			} else if (t.is_a(typeof(Collection))) {
				Collection collection = (default_value != null) ? (Collection)default_value.get_object() : null;
				if (collection == null) {
					warning("No instance of generic type %s given. Element type cannot be determined without an instance.", t.name());
					assert_not_reached();
				}
				populate_collection_from_sequence(collection, sequence);
				v.set_object(collection);
			} else if (t.is_flags()) {
				var flags_class = ((GLibPatch.FlagsClass)t.class_ref());
				uint? flags = null;
				foreach(var scalar in sequence.scalars()) {
					unowned GLibPatch.FlagsValue? flags_value = flags_class.get_value_by_nick(scalar.value);
					if (flags_value != null)
						flags = (flags == null) ? flags_value.value : ((uint)flags) | flags_value.value;
				}
				if (flags != null)
					v.set_flags(flags);
			} else {
				warning("Unsupported sequence type: %s", t.name());
				assert_not_reached();
			}

			return v;
		}

		Value ParseValueSupportingEntityReference(Node node, Type? type=null, Value? default_value=null, bool use_default_for_scalar=true) {
			if (type != null && type.is_a(typeof(Entity)) && data_interface != null)
			{
				var scalar = node as ScalarNode;
				if (scalar != null) {
					try {
						var entity_provider = data_interface.get_provider(type);
						if (entity_provider != null) {
							var e = entity_provider.i_get_entity(scalar.value);
							if (e == null)
								return Value(typeof(Fail));
							Value v = Value(type);
							v.take_object(e);
							return v;
						}
						var entity = (Entity)data_interface.load_internal(scalar.value, null, type);
						return entity;
					} catch(Error e) {
						warning("Error loading %s entity id %s: %s", type.name(), scalar.value, e.message);
						return Value(typeof(Fail));
					}
				}
			}
			return ParseValue(node, type, default_value, use_default_for_scalar);
		}
	}
}
