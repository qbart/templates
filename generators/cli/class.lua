-----
-- C++ header/class generator
-----

local helpers = require "helpers"

local project = arg[1]
local full_class_name = arg[2]
local mode = arg[3]
local header_template_path = 'templates/class.h'
local source_template_path = 'templates/class.cpp'

if (project == nil) or (full_class_name == nil) then
    print('Error: Invalid arguments')
    print('USAGE')
    print('  gen class $1 $2 $3')
    print('  $1 - project folder')
    print('  $2 - class name with namespace: namespace/.../MyClass (only first part of path is a namespace)')
    print('  $3 - (optional) mode')
    print('       lib - add export header for shared library')
else
    local include_export = (mode == 'lib')
    local class_chunks = full_class_name:split('/')
    local class_name = class_chunks[#class_chunks]

    -- build paths where to create .h, .cpp files based on the mode
    local path_to_header = ''
    local path_to_source = 'src/' .. full_class_name .. '.cpp'

    if include_export then
        path_to_header = 'include/' .. full_class_name .. '.h'
    else
        path_to_header = 'src/' .. full_class_name .. '.h'
    end
    local output_header_file_path = '../' .. project .. '/' .. path_to_header
    local output_source_file_path = '../' .. project .. '/' .. path_to_source

    -- create folders for namespace or folders if needed
    local headerDir = string.gsub(output_header_file_path, '/' .. class_name .. '.h', '')
    local sourceDir = string.gsub(output_source_file_path, '/' .. class_name .. '.cpp', '')
    helpers.mkdir(headerDir)
    helpers.mkdir(sourceDir)

    -- construct replacement values
    local namespace_exists = (#class_chunks > 1)
    local namespace_name = namespace_exists and class_chunks[1] or ''
    local replacement_values = {}
    replacement_values['$FULL_CLASS_NAME'] = full_class_name
    replacement_values['$EXPORT_CLASS'] = include_export and (project:upper() .. '_API ') or ''
    replacement_values['$INCLUDE'] = include_export and ('#include <' .. project:capitalize() .. 'Exports.h>\n') or ''
    replacement_values['$CLASS_NAME'] = class_name
    replacement_values['$NAMESPACE_BEGIN'] = namespace_exists and ('\nnamespace ' .. namespace_name .. '\n{\n') or ''
    replacement_values['$NAMESPACE_END'] = namespace_exists and '\n}' or ''

    -- process templates and generate files
    helpers.create_from_template(header_template_path, output_header_file_path, replacement_values)
    helpers.create_from_template(source_template_path, output_source_file_path, replacement_values)

    -- paths that needs to be added to CMake files list
    print('Add these manually to ' .. project .. '/CMakeLists.txt\n')
    print(path_to_header)
    print(path_to_source)
end
