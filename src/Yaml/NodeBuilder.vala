/* NodeBuilder.vala
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
	public class NodeBuilder
	{
		public Node build<T>(T value) {
			Value val = ValueHelper.populate_value<T>(value);
			return build_value(val);
		}
		public Node build_value(Value value) {
			return BuildValueAssert(value);
		}
		public Node build_yaml_object(IYamlObject yaml_object) {
			return yaml_object.i_build_yaml_node(this);
		}
		
		public MappingNode populate_mapping_with_object_properties(Object obj, MappingNode? mapping = null) {
			var mappingNode = mapping ?? new MappingNode();
			PopulateObjectMapping(mappingNode, obj);
			return mappingNode;
		}
		public MappingNode populate_mapping_with_map_items(Map map, MappingNode? mapping = null) {
			var mappingNode = mapping ?? new MappingNode();
			var indirect = IndirectGenericsHelper.Gee.Map.indirect(map);
			Value[] keys = indirect.get_keys(map);
			foreach (Value key in keys) {
				Value value = indirect.get(map, key);
				add_item_to_mapping(key, value, mappingNode);
			}
			return mappingNode;			
		}
		public SequenceNode populate_sequence_with_items(Iterable iterable, SequenceNode? sequence = null) {
			var values = IndirectGenericsHelper.Gee.Iterable.get_values(iterable);
			return populate_sequence_with_values(values, sequence);
		}
		public SequenceNode populate_sequence_with_values(Value[] values, SequenceNode? sequence = null) {
			var sequenceNode = sequence ?? new SequenceNode();
			foreach(var value in values) {
				var valueNode = BuildValueAssertSupportingEntityReference(value);
				sequence.add(valueNode);
			}
			return sequenceNode;
		}
		
		public bool add_object_property_to_mapping(Object obj, string property_name, MappingNode mapping) {
			return AddObjectPropertyMapping(mapping, obj, property_name);
		}
		public void add_item_to_mapping(Value key, Value value, MappingNode mapping) {
			try {
				var keyNode = BuildValueSupportingEntityReference(key);
				var valueNode = BuildValueSupportingEntityReference(value);
				mapping[keyNode] = valueNode;
			} catch (Error e) {
				warning(e.message);
				assert_not_reached();
			}
		}
		public void add_value_to_sequence(Value value, SequenceNode sequence) {
			var valueNode = BuildValueAssertSupportingEntityReference(value);
			sequence.add(valueNode);
		}

		Node BuildValue(Value value) throws RuntimeError
		{
			if (value.holds(typeof(Object)))
				return BuildObject(value.get_object());

			Type type = value.type();
//~ 			if (type == typeof(void *)) {
//~ 				debug("before peek...");
//~ 				var pointer = value.peek_pointer();
//~ 				debug("pointer: %d", (int)pointer);
//~ 				if (pointer == null) {
//~ 					debug("null pointer...");
//~ 					return BuildNull();
//~ 				}
//~ 				type = Type.from_instance(pointer);
//~ 				debug("after from_instance:");
//~ 				debug("pointer to %s...", type.name());
//~ 				if (Value.type_compatible(type, typeof(Object)))
//~ 					return BuildObject((Object)value.get_pointer());
//~ 			}
			if (type.is_flags()) {
				uint flags = value.get_flags();
				GLibPatch.FlagsClass klass = (GLibPatch.FlagsClass)type.class_ref();
				var sequenceNode = new SequenceNode();
				foreach(var val in klass.values) {
					if ((flags & val.value) == val.value)
						sequenceNode.add(new ScalarNode(val.value_nick, Constants.Tag.STR));
				}
				if (sequenceNode.item_count() == 1)
					return sequenceNode.items().first();
				return sequenceNode;
			}
			string tag = Constants.Tag.STR;
			string str_value = null;
			if (type.is_enum())
				str_value = ((EnumClass)type.class_ref()).get_value(value.get_enum()).value_nick;
			else if (type == typeof(string))
				str_value = value.get_string();
			else if (type == typeof(char))
				str_value = value.get_char().to_string();
			else if (type == typeof(uchar))
				str_value = value.get_uchar().to_string();
			else if (type == typeof(bool)) {
				str_value = value.get_boolean().to_string();
				tag = Constants.Tag.BOOL;
			}
			else if (type == typeof(int)) {
				str_value = value.get_int().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(uint)) {
				str_value = value.get_uint().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(long)) {
				str_value = value.get_long().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(ulong)) {
				str_value = value.get_ulong().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(int64)) {
				str_value = value.get_int64().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(uint64)) {
				str_value = value.get_uint64().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(float)) {
				str_value = value.get_float().to_string();
				tag = Constants.Tag.FLOAT;
			}
			else if (type == typeof(double)) {
				str_value = value.get_double().to_string();
				tag = Constants.Tag.FLOAT;
			}
			else if (type == typeof(Type))
				str_value = value.get_gtype().name().dup();

			else if (type.is_a(Type.BOXED)) {
				if (type == typeof(Date)) {
					Date? dt = (Date?)value.get_boxed();
					var buffer = new char[64];
					dt.strftime(buffer, "%x");
					str_value = (string)buffer;
					tag = Constants.Tag.TIMESTAMP;
				} else {
					throw new RuntimeError.ARGUMENT("Unsupported BOXED type: " + type.name());
					//assert_not_reached();
				}
			}
			else if (type.is_classed())
				debug("Is Classed: %s", type.name());
			else {
				throw new RuntimeError.ARGUMENT("Unsupported type: " + type.name());
				//assert_not_reached();
			}

			if (str_value != null)
				return new ScalarNode(str_value, tag);

			return BuildNull();
		}

		Node BuildObject(Object obj)
		{
			// if IYamlObject, emit that
			var yamlObj = obj as IYamlObject;
			if (yamlObj != null)
				return build_yaml_object(yamlObj);

			Type type = obj.get_type();

			// if mapping, build that
			if (type.is_a(typeof(Map)))
				return populate_mapping_with_map_items(obj as Map, new MappingNode());							

			// if sequence, build that
			if (type.is_a(typeof(Iterable)))
				return populate_sequence_with_items(obj as Iterable, new SequenceNode());							

			// build object mapping
			return BuildObjectMapping(obj);
		}

		Node BuildNull()
		{
			return new ScalarNode("", Constants.Tag.NULL, false, false, ScalarStyle.PLAIN);
		}

		MappingNode BuildObjectMapping(Object obj)
		{
			var mappingNode = new MappingNode();
			PopulateObjectMapping(mappingNode, obj);
	    	return mappingNode;
		}
		void PopulateObjectMapping(MappingNode node, Object obj)
		{
			unowned ObjectClass klass = obj.get_class();
	    	var properties = klass.list_properties();
	    	foreach(var prop in properties)
				AddObjectParamSpecMapping(node, obj, prop);
		}
		bool AddObjectParamSpecMapping(MappingNode node, Object obj, ParamSpec property)
		{
			if ((property.flags & ParamFlags.READWRITE) == ParamFlags.READWRITE) {
				var keyNode = BuildValueAssert(property.name);
				Value existing_prop_value = Value(property.value_type);
				obj.get_property(property.name, ref existing_prop_value);
				node[keyNode] = BuildValueAssertSupportingEntityReference(existing_prop_value, obj);
				return true;
			}
			return false;
		}
		bool AddObjectPropertyMapping(MappingNode node, Object obj, string propertyName)
		{
			unowned ObjectClass klass = obj.get_class();
			var property = klass.find_property(propertyName);
			if (property == null)
				return false;
			var keyNode = BuildValueAssert(property.name);
			Value existing_prop_value = Value(property.value_type);
			obj.get_property(property.name, ref existing_prop_value);
			node[keyNode] = BuildValueAssertSupportingEntityReference(existing_prop_value, obj);
			return true;
		}

		Node BuildValueSupportingEntityReference(Value value) throws RuntimeError
		{
			Type type = value.type();
			if (type.is_a(typeof(Entity)))
			{
				var entity = (Entity)value.get_object();
				string id = entity.id;
				if (id == null)
					id = entity.i_generate_id();
				return BuildValue(id);
			}
			return BuildValue(value);
		}
		Node BuildValueAssert(Value value) {
			try {
				return BuildValue(value);
			} catch (Error e) {
				warning(e.message);
				assert_not_reached();
			}
		}
		Node BuildValueAssertSupportingEntityReference(Value value, Object? obj=null) {
			try {
				return BuildValueSupportingEntityReference(value);
			} catch (Error e) {
				if (obj != null) {
					var yobj = obj as IYamlObject;
					if (yobj != null) {
						var node = yobj.i_build_unhandled_value_node(this, value);
						if (node != null)
							return node;
					}
				}
				warning(e.message);
				assert_not_reached();
			}
		}
	}
}

