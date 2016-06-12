local helpers = {}

-----
-- string utils
-----
function string:split(sep)
    local pattern = string.format('([^%s]+)', sep)
    local fields = {}

    for chunk in self:gmatch(pattern) do
        fields[#fields + 1] = chunk
    end

    return fields
end

function string:capitalize()
    return self:gsub("^%l", string.upper)
end

-----
--- various
-----

function helpers.mkdir(path)
    local win_path = path:gsub('/', '\\')
    local cmd = 'mkdir ' .. win_path
    os.execute(cmd)
end

function helpers.create_from_template(in_file_path, out_file_path, replacement_values)
    local output_file = assert( io.open(out_file_path, 'w') )

    for line in io.lines(in_file_path) do
        local out_line = line

        for key, value in pairs(replacement_values) do
            out_line = out_line:gsub(key, value)
        end

        output_file:write(out_line .. '\n')
    end

    output_file:close()
end

return helpers
