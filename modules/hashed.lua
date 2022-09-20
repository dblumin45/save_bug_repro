-- Used to retrieve a string from its hashed value
local hashed = {}

function hash_with_reference(s)
	local h = hashed[s]

	if not h and type(s) == "string" then
		h = hash(s)
		hashed[s] = h
		hashed[h] = s
	end
	-- return nil indicate it was passed a hash value that was not stored in hashed
	return h
end

-- put any string here you want to prehash, and can't hash_with_reference at runtime (i.e. go.properties)
local keys = {
	"player"
}

-- reciprocally store reference from string to hash and vice-versa
for _,v in pairs(keys) do
	hash_with_reference(v)
end

return hashed