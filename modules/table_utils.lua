local table_utils = {}

-- safely traverse through deep-nested lists without having to check if each level exists
function table_utils.safe_index(origin, ...)
	local path_len = select("#", ...)
	assert(origin and path_len > 0)
	local current = origin
	for i = 1, path_len do
		local index = select(i, ...)
		current = current[index]
		if not current then
			return
		end
	end
	return current
end

local function setn(t, n)
	local metatable = getmetatable(t) or {}
	metatable.__len = metatable.__len or function() return n end
	setmetatable(t, metatable)
end
function table_utils.clear_table(t, basic)
	-- clear all elements and reset table length to 0
	for i,v in pairs(t) do
		t[i] = nil
	end
	if not basic then
		setn(t, 0)
	end
end

local function deep_equals(x, y)
	if type(x) == "table" and type(y) == "table" then
		for i,v in pairs(x) do
			local match = deep_equals(v, y[i])
			if not match then
				return false
			end
		end
		return true
	else
		local exists, _x = pcall(hash_to_hex, x)
		if exists then
			x = _x
		end
		exists, _y = pcall(hash_to_hex, y)
		if exists then
			y = _y
		end
		return x == y
	end	
end

local function compare_elements(id, key, i, v) 
	if id then
		local compare_to = v[ id[1] ]
		local value = id[2]
		if value == compare_to then
			return i, v 
		end
	elseif deep_equals(v, key) then
		return i, v
	end
	return
end

function table_utils.table_contains(tab, key, iter, id)
	if not tab then return end
	iter = iter or pairs

	if iter then
		local tab_size = #tab 
		for i = 1, tab_size do
			local v = tab[i]
			local _i, _v = compare_elements(id, key, i, v)
			if _i then
				return _i, _v 
			end
		end	
	else
		for k,v in pairs(tab) do
			local _k, _v = compare_elements(id, key, k, v)
			if _k then
				return _k, _v 
			end
		end
	end
	return false
end
local deep_copy
function table_utils.deep_copy(source, destination)
	if source then
		if type(source) == "table" then
			destination = destination or {}
			for k,v in pairs(source) do
				destination[k] = deep_copy(v)
			end
		elseif type(source) == "userdata" then
			if pcall(get_value, source, "w") then
				destination = vmath.vector4(source.x, source.y, source.z, source.w)
			elseif pcall(get_value, source, "x") then
				destination = vmath.vector3(source.x, source.y, source.z)
			else
				destination = source
			end
		else
			destination = source
		end
	end
	return destination
end
deep_copy = table_utils.deep_copy

function table_utils.shallow_copy(source, destination)
	destination = destination or {}
	table_utils.clear_table(destination, true)
	for i,v in pairs(source) do
		destination[i] = v
	end
	setn(destination, #source)
	
	return destination
end

function table_utils.swap(t, x, y)
	local temp_x = t[x]
	t[x] = t[y]
	t[y] = temp_x
end

function table_utils.is_empty(t)
	if not t then 
		return true
	end
	for _,_ in pairs(t) do
		return false
	end
	return true
end

function table_utils.add_to_table(destination, source, overwrite, ignore_tables)
	if source and destination then
		for i,v in pairs(source) do
			if (not ignore_tables or type(v) ~= "table") and (not destination[i] or overwrite) then
				destination[i] = v
			end
		end
	end
end

return table_utils