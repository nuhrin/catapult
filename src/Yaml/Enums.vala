/* Enums.vala
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
 

namespace Catapult.Yaml
{	
	public enum EncodingType {
		/* Let the parser choose the encoding. */
		ANY_ENCODING,
		/* The default UTF-8 encoding. */
		UTF8_ENCODING,
		/* The UTF-16-LE encoding with BOM. */
		UTF16LE_ENCODING,
		/* The UTF-16-BE encoding with BOM. */
		UTF16BE_ENCODING
	}

	public enum NodeType {
		NONE,
		SCALAR,
		SEQUENCE,
		MAPPING
	}

	public enum ScalarStyle {
		ANY,
		PLAIN,
		SINGLE_QUOTED,
		DOUBLE_QUOTED,
		LITERAL,
		FOLDED
	}

	public enum SequenceStyle{
		ANY,
		BLOCK,
		FLOW
	}

	public enum MappingStyle {
		ANY,
		BLOCK,
		FLOW
	}
}
