local function addsupers(target,supers)
	for i=1,#supers do -- faster than ipairs
		local super = supers[i]
		for k,v in pairs(super) do
			if not target[k] then
				target[k] = v
			end
		end
		addsupers(target, super.__supers or {})
	end
end

local function instantiate(tk,...)
	local instance={}
	setmetatable(instance,tk.__classmeta)
	return (instance.new and instance:new(...)) or instance
end

local function fix_supers(tk,...)
	tk.__call = instantiate
	addsupers(tk,tk.__supers)
	return instantiate(tk,...)
end

local function newclass(klstab,kls)
	if rawget(getfenv(), kls) then
		error("The class `"..kls.."` is already defined in this namespace!", 2)
	end
	return function(...)
		local meta = {}
		local supers = {...}
		meta.__classmeta = {
			__index=meta, -- this is the actual metatable for instances
			__tostring = function(self)
				return kls and ("instance of `"..kls.."`") or "instance of anonymous class"
			end
		}
		meta.__class = kls -- class name, just for reference
		meta.__supers = supers -- list of superclasses
		meta.__index = supers[1]
		meta.__tostring = function(self)
			return kls and ("class `"..kls.."`") or "anonymous class"
		end
		meta.__call = fix_supers
		meta.instanceof = function(self,...)
			assert(getmetatable(self)==meta.__classmeta)
			local totest = {...}
			for i=1,#totest do
				for j=1,#supers do
					if meta.__supers[j] == totest[i] then
						return true
					end
				end
			end
			return false
		end
		setmetatable(meta, meta)
		if kls then rawset(getfenv and getfenv() or _ENV, kls, meta) end
		return meta
	end
end

class = setmetatable({}, {
	__index = newclass,
	__call = function(t,...)
		return newclass(nil,nil)(...)
	end
})

return class
