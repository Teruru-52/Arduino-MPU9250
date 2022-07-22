%% import data
data = csvread('data.csv');
mx = data(:,1);
my = data(:,2);
mz = data(:,3);

%% matrix
% p = []
A = [p(1) p(4) p(6);
    p(4) p(2) p(5)
    p(6) p(5) p(3)];

B = [p(7), p(8), p(9)];

[P, Lambda] = eig(A);

Ptrans = transpose(P)

C = 1/2 * inv(Lambda) * transpose(B * P)
 
W = (B * P(:,1))^2 / (4 * Lambda(1,1)) + (B * P(:,2))^2 / (4 * Lambda(2,2)) + (B * P(:,3))^2 / (4 * Lambda(3,3)) - 1

lam = [sqrt(Lambda(1,1)), sqrt(Lambda(2,2)), sqrt(Lambda(3,3))];
S = 1/ sqrt(W) * diag(lam);

% X = S * (transpose(P)*data + C);
%% raw data to calibrated data
data = data';
X = S * (transpose(P)*data + C);
X = X';
mX = X(:,1);
mY = X(:,2);
mZ = X(:,3);
%% plot mx, my, mz
plot3(mx,my,mz,'.','Color','r');
grid on;
pbaspect([1 1 1]);
xlabel('$mz$','Interpreter','latex');
ylabel('$my$','Interpreter','latex');
zlabel('$mz$','Interpreter','latex');
h_axes = gca;
h_axes.XAxis.FontSize = 25;
h_axes.YAxis.FontSize = 25;
h_axes.ZAxis.FontSize = 25;
%% plot MX, MY, MZ
close all

a = [-1; -1; -1; 0; 0; 0; 0; 0; 0];
f2 = @(x,y,z) a(1)*x.^2 + a(2)*y.^2 + a(3)*z.^2 + 2*a(4)*x*y + 2*a(5)*y*z + 2*a(6)*z*x + a(7)*x + a(8)*y + a(9)*z  + 1;

plot3(mX,mY,mZ,'.','Color','b','MarkerSize',10);
grid on;
hold on;
fimplicit3(f2,'EdgeColor','none','FaceAlpha',.2);
pbaspect([1 1 1]);
xlabel('$mX$','Interpreter','latex');
ylabel('$mY$','Interpreter','latex');
zlabel('$mZ$','Interpreter','latex');
xlim([-1.5 1.5])
ylim([-1.5 1.5])
zlim([-1.5 1.5])
xticks([-1.5:0.5:1.5])
yticks([-1.5:0.5:1.5])
zticks([-1.5:0.5:1.5])
h_axes = gca;
h_axes.XAxis.FontSize = 25;
h_axes.YAxis.FontSize = 25;
h_axes.ZAxis.FontSize = 25;

quiver3(0,0,0,0.5,0,0,'LineWidth',2);
quiver3(0,0,0,0,0.5,0,'LineWidth',2);
quiver3(0,0,0,0,0,0.5,'LineWidth',2);

%% raw data to calibrated data　(伸縮なし)
X2 = transpose(P)*data + C;
X2 = X2';
mX2 = X2(:,1);
mY2 = X2(:,2);
mZ2 = X2(:,3);
%% plot MX2, MY2, MZ2
plot3(mX2,mY2,mZ2,'.','Color','b','MarkerSize',10);
grid on;
hold on;
pbaspect([1 1 1]);
xlabel('$mX$','Interpreter','latex');
ylabel('$mY$','Interpreter','latex');
zlabel('$mZ$','Interpreter','latex');
xlim([-100 100])
ylim([-100 100])
zlim([-100 100])
h_axes = gca;
h_axes.XAxis.FontSize = 25;
h_axes.YAxis.FontSize = 25;
h_axes.ZAxis.FontSize = 25;

quiver3(0,0,0,25,0,0,'LineWidth',2);
quiver3(0,0,0,0,25,0,'LineWidth',2);
quiver3(0,0,0,0,0,25,'LineWidth',2);

%% キャリブレーション前後の比較
figure(1);
subplot(1,2,1);
plot3(mx,my,mz,'.','Color','r','MarkerSize',10);
grid on;
hold on;
f = @(x,y,z) p(1)*x.^2 + p(2)*y.^2 + p(3)*z.^2 + 2*p(4)*x*y + 2*p(5)*y*z + 2*p(6)*z*x + p(7)*x + p(8)*y + p(9)*z + 1;
fimplicit3(f,'EdgeColor','none','FaceAlpha',.2);
pbaspect([1 1 1]);
xlabel('$mx$ [nT]','Interpreter','latex');
ylabel('$my$ [nT]','Interpreter','latex');
zlabel('$mz$ [nT]','Interpreter','latex');
xlim([-100 100])
ylim([-50 150])
zlim([-100 100])
xticks([-100:50:100])
yticks([-50:50:150])
zticks([-100:50:100])
% legend('Data','Approximate Ellipse');
% legend('Data','Approximate Ellipse','FontSize',25);
h_axes = gca;
h_axes.XAxis.FontSize = 25;
h_axes.YAxis.FontSize = 25;
h_axes.ZAxis.FontSize = 25;

quiver3(C2(1),C2(2),C2(3),p1(1),p1(2),p1(3),'LineWidth',2);
quiver3(C2(1),C2(2),C2(3),p2(1),p2(2),p2(3),'LineWidth',2);
quiver3(C2(1),C2(2),C2(3),p3(1),p3(2),p3(3),'LineWidth',2);

subplot(1,2,2);
a = [-1; -1; -1; 0; 0; 0; 0; 0; 0];
f2 = @(x,y,z) a(1)*x.^2 + a(2)*y.^2 + a(3)*z.^2 + 2*a(4)*x*y + 2*a(5)*y*z + 2*a(6)*z*x + a(7)*x + a(8)*y + a(9)*z  + 1;

plot3(mX,mY,mZ,'.','Color','b','MarkerSize',10);
grid on;
hold on;
fimplicit3(f2,'EdgeColor','none','FaceAlpha',.2);
pbaspect([1 1 1]);
xlabel('$mX$','Interpreter','latex');
ylabel('$mY$','Interpreter','latex');
zlabel('$mZ$','Interpreter','latex');
xlim([-1.5 1.5])
ylim([-1.5 1.5])
zlim([-1.5 1.5])
xticks([-1.5:0.5:1.5])
yticks([-1.5:0.5:1.5])
zticks([-1.5:0.5:1.5])
h_axes = gca;
h_axes.XAxis.FontSize = 25;
h_axes.YAxis.FontSize = 25;
h_axes.ZAxis.FontSize = 25;

quiver3(0,0,0,0.5,0,0,'LineWidth',2);
quiver3(0,0,0,0,0.5,0,'LineWidth',2);
quiver3(0,0,0,0,0,0.5,'LineWidth',2);

%% import calibrated data
data = csvread('calib_data.csv');
mx_calib = data(:,1);
my_calib = data(:,2);
mz_calib = data(:,3);

%% plot
plot3(mx_calib,my_calib,mz_calib,'.','Color','r','MarkerSize',10);
grid on;
hold on;
pbaspect([1 1 1]);
xlabel('$mX$','Interpreter','latex');
ylabel('$mY$','Interpreter','latex');
zlabel('$mZ$','Interpreter','latex');
xlim([-1.5 1.5])
ylim([-1.5 1.5])
zlim([-1.5 1.5])
xticks([-1.5:0.5:1.5])
yticks([-1.5:0.5:1.5])
zticks([-1.5:0.5:1.5])
h_axes = gca;
h_axes.XAxis.FontSize = 25;
h_axes.YAxis.FontSize = 25;
h_axes.ZAxis.FontSize = 25;

quiver3(0,0,0,0.5,0,0,'LineWidth',2);
quiver3(0,0,0,0,0.5,0,'LineWidth',2);
quiver3(0,0,0,0,0,0.5,'LineWidth',2);

quiver3(C2(1),C2(2),C2(3),p1(1),p1(2),p1(3),'LineWidth',2);
quiver3(C2(1),C2(2),C2(3),p2(1),p2(2),p2(3),'LineWidth',2);
quiver3(C2(1),C2(2),C2(3),p3(1),p3(2),p3(3),'LineWidth',2);