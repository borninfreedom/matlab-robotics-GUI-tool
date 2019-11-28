clear
clc
FIGURE_ROW = 1;
FIGURE_COL = 2;
INDEX = 1;
%% 建立dh参数

% UR10e
% Kinematics	theta [rad]	a [m]       d [m]       alpha [rad]	Dynamics	Mass [kg]	Center of Mass [m]
% Joint 1	      0	         0           0.1807      π/2        Link 1	7.369	[0.021, 0.000, 0.027]
% Joint 2         0         -0.6127     	0         0          Link 2	13.051	[0.38, 0.000, 0.158]
% Joint 3         0         -0.57155    	0         0        	Link 3	3.989	[0.24, 0.000, 0.068]
% Joint 4         0          0            0.17415	 π/2        Link 4	2.1	[0.000, 0.007, 0.018]
% Joint 5         0          0           0.11985	 -π/2       Link 5	1.98	[0.000, 0.007, 0.018]
% Joint 6         0          0           0.11655	  0      	Link 6	0.615	[0, 0, -0.026]

% link : theta d  a  alpha
L(1) = Link([0, 0.1807,  0,         pi/2]);
L(2) = Link([0, 0,      -0.61127,  0]);
L(3) = Link([0, 0,      -0.57155,  0]);
L(4) = Link([0, 0.17415, 0,        pi/2]);
L(5) = Link([0, 0.11985, 0,        -pi/2]);
L(6) = Link([0, 0.11655, 0,        0]);

ur_robot = SerialLink(L, 'name', 'ur robot')
mdl_planar2
T = ur_robot.fkine([0 -1 1 0 0 0 ])
subplot(FIGURE_ROW,FIGURE_COL,1);
ur_robot.plot([0 -1 1 0 0 0])
iT = ur_robot.ikine(T)
%% 轨迹

pause(1)
T1 = T;
T2 = transl(0, 1, 0);

T3 = transl(1, 0, 0);
T4 = transl(0, -1, 0);
T5 = T;
p1 =[  -0.7071   -0.0000    0.7071    1.4142;
        0.0000   -1.0000   -0.0000   -0.0000;
        0.7071    0.0000    0.7071    1.9142;
             0         0         0    1.0000];


 p2 =[    0.9640   -0.2639   -0.0332    0.9331;
          0.0979    0.2361    0.9668    1.9331;
         -0.2473   -0.9352    0.2534    0.8618;
               0         0         0    1.0000];

Tc=ctraj(p1,p2,50);
Tjtraj=transl(Tc);

t = 0:0.05:0.2;

%traj = ur_robot.jtraj(T1,T2,t');
%traj = ctraj(T1,T2,50);
subplot(FIGURE_ROW,FIGURE_COL,2);

%qplot(t,traj);

subplot(FIGURE_ROW,FIGURE_COL,1);
%plot(ur_robot,traj) % plot带有原图像句柄时，是把曲线数据应用到原图像上。没有原图像时，只把曲线画出来
plot2(Tjtraj);
pause(1)
traj = ur_robot.jtraj(T2,T3,t');
subplot(FIGURE_ROW,FIGURE_COL,2);

qplot(t,traj)
subplot(FIGURE_ROW,FIGURE_COL,1);
plot(ur_robot,traj)

pause(1)
traj = ur_robot.jtraj(T3,T4,t');
subplot(FIGURE_ROW,FIGURE_COL,2);

qplot(t,traj)
subplot(FIGURE_ROW,FIGURE_COL,1);
plot(ur_robot,traj) % plot带有原图像句柄时，是把曲线数据应用到原图像上。没有原图像时，只把曲线画出来
pause(1)

pause(1)
traj = ur_robot.jtraj(T4,T5,t');
subplot(FIGURE_ROW,FIGURE_COL,2);

qplot(t,traj)
subplot(FIGURE_ROW,FIGURE_COL,1);
plot(ur_robot,traj) % plot带有原图像句柄时，是把曲线数据应用到原图像上。没有原图像时，只把曲线画出来
pause(1)


