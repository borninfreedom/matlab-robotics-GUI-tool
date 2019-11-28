
% utility
v1 = mat([0, 1, 0]);
v2 = mat([0, 0, 1]);
unit(v1+v2)


m = mat(zeros( 3,4 ));
numcols(m)
numrows(m)

% transform primitives
rotx(.1)
roty(.1)
rotz(.1)

r = rotz(0.1)
r2t(r)


trotx(.1)
troty(.1)
trotz(.1)

t = trotz(0.1)
t2r(t)

t1 = trotx(.1)
t2 = troty(.2)
trinterp(t1, t2, 0)
trinterp(t1, t2, 1)
trinterp(t1, t2, 0.5)

% predicates
isvec(v1)
isvec(r)
isvec(t)

isrot(v1)
isrot(r)
isrot(t)

ishomog(v1)
ishomog(r)
ishomog(t)
det(t)

% translational matrices
transl(0.1, 0.2, 0.3)
transl( [0.1, 0.2, 0.3] )
transl( mat([0.1, 0.2, 0.3]) )
t = transl(0.1, 0.2, 0.3)
transl(t)

% angle conversions
eul2r(.1, .2, .3)
eul2r( [.1, .2, .3] )
eul2r( mat([.1, .2, .3; .4, .5, .6]) )
eul2r( mat([.1, .2, .3]) )
eul2tr(.1, .2, .3)
eul2tr( [.1, .2, .3] )
eul2tr( mat([.1, .2, .3]) )
te = eul2tr( mat([.1, .2, .3]) )
tr2eul(te)

rpy2r(.1, .2, .3)
rpy2r( [.1, .2, .3] )
rpy2r( mat([.1, .2, .3]) )
rpy2r( mat([.1, .2, .3; .4, .5, .6]) )
rpy2tr(.1, .2, .3)
rpy2tr( [.1, .2, .3] )
rpy2tr( mat([.1, .2, .3]) )
tr = rpy2tr( mat([.1, .2, .3]) )
tr2rpy(tr)

oa2r(v1, v2)
oa2tr(v1, v2)
t = oa2tr(v1, v2)
trnorm(t)

angvec2r( 0.1, mat([1,2,3]) )

% special matrices
%diff2tr( mat([.1, .2 ,.3]) )
%m = diff2tr( mat([.1, .2 ,.3]) )
%diff2tr(m)
m = delta2tr( [.1, .2 ,.3, .4, .5, .6] )
tr2delta(m)

R = rotx(0.2); t = [1 2 3]';
T = rt2tr(R, t);
assertEqual(T, [R t; 0 0 0 1]);

[RR,tt] = tr2rt(T);
assertEqual(RR, R);
assertEqual(tt, t);

T = se2(1, 2, .5);
[RR,tt] = tr2rt(T);
TT = rt2tr(RR, tt);
assertEqual(TT, T);

