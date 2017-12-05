function split_lines(str)
    local t = {}
    local i = 1
    local function helper(line)
        if tonumber(line) then
            t[i] = line
            i = i + 1
        end
        return ""
    end
    helper((str:gsub("(.-)\r?\n", helper)))
    return t
end

function values_to_numbers(array)
    local new_array = {}
    for k, v in pairs(array) do
        new_array[k] = tonumber(v)
    end
    return new_array
end


file = io.open("input.txt", "r")
file_content = file:read("*all")

commands = values_to_numbers(split_lines(file_content))
i = 1
steps = 0
while i > 0 and i <= #commands do
    next_i = i + commands[i]
    commands[i] = commands[i] + 1
    i = next_i
    steps = steps + 1
end
print(steps)

commands = values_to_numbers(split_lines(file_content))
i = 1
steps = 0
while i > 0 and i <= #commands do
    next_i = i + commands[i]
    if commands[i] >= 3 then
        commands[i] = commands[i] - 1
    else
        commands[i] = commands[i] + 1
    end
    i = next_i
    steps = steps + 1
end
print(steps)
