/* DocumentStart.vala
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
 
using YAML;
using Gee;

namespace Catapult.Yaml.Events
{
	public class DocumentStart : Event
	{
		public DocumentStart(VersionDirective? version = null, Iterable<TagDirective>? tag_directives = null, bool implicit = true)
		{
			base(EventType.DOCUMENT_START);
			this.version = version;
			this.tag_directives = new ArrayList<TagDirective>();
			if (tag_directives != null) {
				foreach(var tg in tag_directives)
					this.tag_directives.add(tg);
			}
			is_implicit = implicit;
		}
		public VersionDirective? version { get; private set; }
		public ArrayList<TagDirective> tag_directives { get; private set; }
		public bool is_implicit { get; private set; }

		internal DocumentStart.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.DOCUMENT_START_EVENT)
		{
			base.from_raw(event);
			is_implicit = (event.document_start_implicit != 0);
			if (event.document_start_version_directive != null) {
				version = VersionDirective(
					event.document_start_version_directive.major,
					event.document_start_version_directive.minor);
			}
			tag_directives = new ArrayList<TagDirective>();
			YAML.TagDirective *tag;
			for (tag = event.document_start_tag_directives_start;
	             tag != event.document_start_tag_directives_end;
				 tag ++)
			{
				tag_directives.add(new TagDirective(tag.handle, tag.prefix));
			}
		}
		internal override int nesting_increase { get { return 1; } }

		internal override RawEvent create_raw_event()
		{
			void* version_p = null;
			if (version != null) {
				YAML.VersionDirective version = YAML.VersionDirective() {
					major = version.major,
					minor = version.minor
				};
				version_p = &version;
			}
			void* tags_start = null;
			void* tags_end = null;
			if (tag_directives.size > 0) {
//				YAML.TagDirective[] tags = new YAML.TagDirective[TagDirectives.size];
//				for(int index=0; index<TagDirectives.size; index++)
//				{
//					tags[index] = YAML.TagDirective()
//					{
//						handle = TagDirectives[index].Handle,
//						prefix = TagDirectives[index].Prefix
//					};
//				}
//				tags_start = &tags[0];
//				tags_end = &tags[TagDirectives.size - 1];
			}
			RawEvent event = {0};
			RawEvent.document_start_initialize(ref event, version_p, tags_start, tags_end, is_implicit);
			return event;
		}

		public struct VersionDirective
		{
			public VersionDirective(int major, int minor)
			{
				this.major = major;
				this.minor = minor;
			}
			public int major { get; private set; }
			public int minor { get; private set; }
		}
		public class TagDirective
		{
			public TagDirective(string handle, string prefix)
			{
				this.handle = handle;
				this.prefix = prefix;
			}
			public string handle { get; private set; }
			public string prefix { get; private set; }
		}

	}
}
