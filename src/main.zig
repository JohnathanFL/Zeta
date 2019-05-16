pub fn Matrix(comptime n: usize, comptime m: usize, comptime Type: type) type {
    return packed struct {
        data: [n][m]Type,

        pub inline fn add(self: @This(), other: @This()) @This() {
            // TODO: Make sure this assures that m==m and n==n
            var res = self;
            comptime var i = 0;
            inline while (i < n) : (i += 1) {
                comptime var j = 0;
                inline while (j < m) : (j += 1) {
                    res.data[i][j] += other.data[i][j];
                }
            }


            return res;
        }

        pub inline fn sub(self: @This(), other: @This()) @This() {
            // TODO: Make sure this assures that m==m and n==n
            var res = self;
            comptime var i = 0;
            inline while (i < n) : (i += 1) {
                comptime var j = 0;
                inline while (j < m) : (j += 1) {
                    res.data[i][j] -= other.data[i][j];
                }
            }


            return res;
        }

        pub inline fn mult(self: @This(), comptime p: usize, other: Matrix(m, p, Type)) Matrix(n,p, Type) {
            // Algorithm from https://en.wikipedia.org/wiki/Matrix_multiplication_algorithm
            // TODO: Investigate the Cache Behavior section's algorithm
            var res: Matrix(n, p, Type) = undefined;
            // All hail zig's inlined loops
            comptime var i = 0;
            inline while (i < n) : (i += 1) {
                comptime var j = 0;
                inline while (j < p) : (j += 1) {
                    res.data[i][j] = 0;
                    comptime var k = 0;
                    inline while (k < m) : (k += 1) res.data[i][j] += self.data[i][k] * other.data[k][j];
                }
            }

            return res;
        }

        //pub inline fn pow(self: @This(), )
    };
}

pub fn Vec(comptime n: usize, comptime ty: type) type {
    const typeOf = @typeId(ty);
    comptime if(typeOf != .Float and typeOf != .Integer) @compileError("Vec can only be used with floats and ints!");
    
    // Would be nice
    //comptime if(n > 4) @compileWarning("Vec isn't tested with any n > 4.");

    return packed struct {
        data: [n] ty,

        // pub inline fn init(args: [n]ty) @This() {
        //     var res: @This() = undefined;
        //     comptime var i = 0;
        //     inline while (i < n) : (i += 1) {
        //         res.data[i] = args[i];
        //     }

        //     return res;
        // }

        pub inline fn x(self: @This()) ty {
            return self.data[0];
        }
        pub inline fn y(self: @This()) ty {
            return self.data[1];
        }
        pub inline fn z(self: @This()) ty {
            return self.data[2];
        }
        pub inline fn w(self: @This()) ty {
            return self.data[3];
        }

        pub inline fn r(self: @This()) ty {
            return self.data[0];
        }
        pub inline fn g(self: @This()) ty {
            return self.data[1];
        }
        pub inline fn b(self: @This()) ty {
            return self.data[2];
        }
        pub inline fn a(self: @This()) ty {
            return self.data[3];
        }

        pub inline fn length(self: @This()) ty {
            comptime if(@typeId(ty) != .Float) @compileError("Vec.length needs a floating-point type!");

            var sum: ty = self.data[0];
            comptime var i: usize = 1;
            inline while(i < n) : (i+=1) {
                sum += self.data[i] * self.data[i];
            }

            return @sqrt(ty, sum);
        }

        pub inline fn add(self: @This(), other: @This()) @This() {
            var res = self;
            comptime var i = 0;
            inline while (i < n) : (i += 1) {
                res.data[i] += other.data[i];
            }

            return res;
        }

        pub inline fn sub(self: @This(), other: @This()) @This() {
            var res = self;
            comptime var i = 0;
            inline while (i < n) : (i += 1) {
                res.data[i] -= other.data[i];
            }

            return res;
        }

        pub inline fn addScalar(self: @This(), other: ty) @This() {
            var res = self;
            comptime var i = 0;
            inline while (i < n) : (i += 1) {
                res.data[i] += other;
            }

            return res;
        }

        pub inline fn dot(self: @This(), other: @This()) ty {
            var res = self.x() * other.x();
            comptime var i = 1;
            inline while (i < n) : (i += 1) {
                res += self.data[i] * other.data[i];
            }

            return res;
        }

        // Currently causes a compiler bug
        pub inline fn cross(self: @This(), other: @This()) @This() {
            comptime if(n != 3) @compileError("Cross product is only defined for 3D!");

            return @This() {
                .data = [3]ty{
                    self.data[1] * other.data[2] - self.data[2] * other.data[1],
                    self.data[2] * other.data[0] - self.data[0] * other.data[2],
                    self.data[0] * other.data[1] - self.data[1] * other.data[0]
                }
            };
        }
    };
}

pub fn EulerAngles(comptime n: usize, comptime Type: type) type {
    angles: Vec(n, Type),

    
}