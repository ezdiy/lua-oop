require "oop"

-- simple class creation
A = class()
assert(tostring(A) == "anonymous class")

-- static attribute behavior
A = class {
	static1 = 1,
	static2 = 2
}
i1 = A()
i2 = A()
i1.static1 = 10
assert(i2.static1 == 1)
A.static1 = 20
assert(i1.static1 == 10)
assert(i2.static1 == 20)

-- inheritance
A = class {
	attr = 1
}

B = class(A, {
	attr = 2
})

C = class({ attr = 3 })
a,b,c = A(),B(),C()
assert(a.attr==1)
assert(b.attr==1)
assert(c.attr==3)

-- inheritance
A = class()
function A:new(val)
	self.val = val
	self.attr = 1
end

B = class(A)
function B:new(val)
	A.new(self, val)
	assert(self.attr == 1)
	self.attr = 2
end
assert(B().attr == 2)

-- multiple inheritance
A.a = 1
B.b = 2
C = class(A,B)
c=C(4)
assert(c.val==4 and c.a == 1 and c.b == 2)

-- global class uniqueness
class.Test()
assert(not pcall(function() class.Test() end))

-- instanceof
class.Test2(Test)
t=Test2()
assert(t:instanceof(Test))

print("All tests passed")

