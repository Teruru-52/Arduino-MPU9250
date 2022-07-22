%% import data
clear

data = csvread('data2.csv');
mx = data(:,1);
my = data(:,2);
mz = data(:,3);

%% least square method
n = length(mx);
for i = 1:1:n
    M(i,1) = mx(i)^2;
    M(i,2) = my(i)^2;
    M(i,3) = mz(i)^2;
    M(i,4) = 2*mx(i)*my(i);
    M(i,5) = 2*my(i)*mz(i);
    M(i,6) = 2*mz(i)*mx(i);
    M(i,7) = mx(i);
    M(i,8) = my(i);
    M(i,9) = mz(i);
    I(i,1) = -1;
end

p = M\I;

%% matrix
% p = []
A = [p(1) p(4) p(6);
    p(4) p(2) p(5)
    p(6) p(5) p(3)];

[P, Lambda] = eig(A);

p1 = P(:,1)*25;
p2 = P(:,2)*25;
p3 = P(:,3)*25;

%% center point
A2 = 2*A;
B2 = -[p(7); p(8); p(9)];
C2 = A2\B2;
%% plot
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

%% test plot
a = [-1; -1; -1; 0; 0; 0; 0; 0; 0];
f = @(x,y,z) a(1)*x.^2 + a(2)*y.^2 + a(3)*z.^2 + 2*a(4)*x*y + 2*a(5)*y*z + 2*a(6)*z*x + a(7)*x + a(8)*y + a(9)*z  + 1;
fimplicit3(f,'EdgeColor','[1 1 1]','FaceAlpha',.2);
pbaspect([1 1 1]);
xlabel('$mz$','Interpreter','latex');
ylabel('$my$','Interpreter','latex');
zlabel('$mz$','Interpreter','latex');
h_axes = gca;
h_axes.XAxis.FontSize = 25;
h_axes.YAxis.FontSize = 25;
h_axes.ZAxis.FontSize = 25;
