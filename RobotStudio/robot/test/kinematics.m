p560

% at zero pose
t = fkine(p560, qz)
t
q = ikine560(p560, t)
q
fkine(p560, q)
ikine560(p560, t, 'r')
ikine560(p560, t, 'rn')

ikine(p560, t)

% at nominal pose
qn
t = fkine(p560, qn)
t
%q = ikine560(p560, t)
q
fkine(p560, q)
ikine(p560, t, [0, 0.7, 3, 0, 0.7, 0])

% along trajectory
[q,qd,qdd] = jtraj(qz, qr, 20)
fkine(p560, q)

t1 = fkine(p560, qz)
t2 = fkine(p560, qr)
traj = ctraj(t1, t2, 5)
ikine(p560, traj)
