using YAML;
using Gee;

namespace YamlDB.Yaml.Events
{
	public class DocumentStart : Event
	{
		public DocumentStart(VersionDirective? version = null, Iterable<TagDirective>? tag_directives = null, bool implicit = true)
		{
			base(EventType.DOCUMENT_START);
			Version = version;
			TagDirectives = new ArrayList<TagDirective>();
			if (tag_directives != null) {
				foreach(var tg in tag_directives)
					TagDirectives.add(tg);
			}
			IsImplicit = implicit;
		}
		public VersionDirective? Version { get; private set; }
		public ArrayList<TagDirective> TagDirectives { get; private set; }
		public bool IsImplicit { get; private set; }

		internal DocumentStart.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.DOCUMENT_START_EVENT)
		{
			base.from_raw(event);
			IsImplicit = (event.data.document_start.implicit != 0);
			if (event.data.document_start.version_directive != null) {
				Version = VersionDirective(
					event.data.document_start.version_directive.major,
					event.data.document_start.version_directive.minor);
			}
			TagDirectives = new ArrayList<TagDirective>();
			YAML.TagDirective *tag;
			for (tag = event.data.document_start.tag_directives.start;
	             tag != event.data.document_start.tag_directives.end;
				 tag ++)
			{
				TagDirectives.add(new TagDirective(tag.handle, tag.prefix));
			}
		}
		internal override int NestingIncrease { get { return 1; } }

		internal override RawEvent create_raw_event()
		{
			void* version_p = null;
			if (Version != null) {
				YAML.VersionDirective version = YAML.VersionDirective() {
					major = Version.Major,
					minor = Version.Minor
				};
				version_p = &version;
			}
			void* tags_start = null;
			void* tags_end = null;
			if (TagDirectives.size > 0) {
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
			RawEvent.document_start_initialize(ref event, version_p, tags_start, tags_end, IsImplicit);
			return event;
		}

		public struct VersionDirective
		{
			public VersionDirective(int major, int minor)
			{
				Major = major;
				Minor = minor;
			}
			public int Major { get; private set; }
			public int Minor { get; private set; }
		}
		public class TagDirective
		{
			public TagDirective(string handle, string prefix)
			{
				Handle = handle;
				Prefix = prefix;
			}
			public string Handle { get; private set; }
			public string Prefix { get; private set; }
		}

	}
}
