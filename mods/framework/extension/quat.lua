
local quat_meta = {}
quat_meta.__index = quat_meta
QUATERNION = quat_meta

function IsQuaternion(q)
    return type(q) == "table" and type(q[1]) == "number" and type(q[2]) == "number" and type(q[3]) == "number" and type(q[4]) == "number"
end

function MakeQuaternion(v)
    return setmetatable(v, quat_meta)
end

function Quaternion(i, j, k, r)
    if IsQuaternion(i) then i, j, k, r = i[1], i[2], i[3], i[4] end
    return MakeQuaternion {i or 0, j or 0, k or 0, r or 1}
end

function quat_meta:Clone()
    return MakeQuaternion {self[1], self[2], self[3], self[4]}
end

local QuatStr = QuatStr
function quat_meta:__tostring()
    return QuatStr(self)
end

function quat_meta:__unm()
    return MakeQuaternion {-self[1], -self[2], -self[3], -self[4]}
end

function quat_meta:Add(o)
    if IsQuaternion(o) then
        self[1] = self[1] + o[1]
        self[2] = self[2] + o[2]
        self[3] = self[3] + o[3]
        self[4] = self[4] + o[4]
    else
        self[1] = self[1] + o
        self[2] = self[2] + o
        self[3] = self[3] + o
        self[4] = self[4] + o
    end
    return self
end

function quat_meta.__add(a, b)
    if not IsQuaternion(a) then a, b = b, a end
    return quat_meta.Add(quat_meta.Clone(a), b)
end

function quat_meta:Sub(o)
    if IsQuaternion(o) then
        self[1] = self[1] - o[1]
        self[2] = self[2] - o[2]
        self[3] = self[3] - o[3]
        self[4] = self[4] - o[4]
    else
        self[1] = self[1] - o
        self[2] = self[2] - o
        self[3] = self[3] - o
        self[4] = self[4] - o
    end
    return self
end

function quat_meta.__sub(a, b)
    if not IsQuaternion(a) then a, b = b, a end
    return quat_meta.Sub(quat_meta.Clone(a), b)
end

function quat_meta:Mul(o)
    local i1, j1, k1, r1 = self[1], self[2], self[3], self[4]
    local i2, j2, k2, r2 = o[1], o[2], o[3], o[4]
    self[1] = j1*k2 - k1*j2 + r1*i2 + i1*r2
    self[2] = k1*i2 - i1*k2 + r1*j2 + j1*r2
    self[3] = i1*j2 - j1*i2 + r1*k2 + k1*r2
    self[4] = r1*r2 - i1*i2 - j1*j2 - k1*k2
    return self
end

function quat_meta.__mul(a, b)
    if IsVector(b) then return VECTOR.__mul(b, a) end
    return MakeQuaternion(QuatRotateQuat(a, b))
end

function quat_meta.__eq(a, b)
    return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

function quat_meta:LengthSquare()
    return self[1] ^ 2 + self[2] ^ 2 + self[3] ^ 2 + self[4] ^ 2
end

function quat_meta:Length()
    return math.sqrt(quat_meta.LengthSquare(self))
end

local QuatSlerp = QuatSlerp
function quat_meta:Slerp(o, n)
    return MakeQuaternion(QuatSlerp(self, o, n))
end