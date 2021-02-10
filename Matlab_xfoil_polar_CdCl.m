clear;
clc;
close;

% User Inputs
NACA       = '4412';
AoA        = '0';
re         = '3000000';
ma         = '0.1';
iter       = '250';
numNodes   = '35';
saveFlnmAF = 'Save_Airfoil.txt';
saveFlnmCp = 'Save_Cp.txt';
saveFlnmCl = 'Save_Cl.txt';

% Delete files if they exist
if (exist(saveFlnmAF,'file'))
    delete(saveFlnmAF);
end
if (exist(saveFlnmCp,'file'))
    delete(saveFlnmCp);
end
if (exist(saveFlnmCl,'file'))
    delete(saveFlnmCl);
end

% Create the airfoil
fid = fopen('xfoil_input.txt','w');
fprintf(fid,['NACA ' NACA '\n']);
fprintf(fid,'PPAR\n');
% fprintf(fid,['N ' numNodes '\n']);
fprintf(fid,'\n\n');

% Save the airfoil data points
fprintf(fid,['PSAV ' saveFlnmAF '\n']);

% Find the Cp vs. X plot
fprintf(fid,'OPER\n');
fprintf(fid,['iter ' iter '\n']);
fprintf(fid,'visc\n');
fprintf(fid,'\n');
fprintf(fid,['re ' re '\n']);
fprintf(fid,['m ' ma '\n']);
fprintf(fid,'seqp\n');
fprintf(fid,'pacc\n');
fprintf(fid,[saveFlnmCl '\n\n']);
fprintf(fid,'aseq -20 20 1 \n');

% Close file
fclose(fid);
% Run XFoil using input file
cmd = 'xfoil.exe < xfoil_input.txt';
[status,result] = system(cmd);

%% READ DATA FILE: AIRFOIL
saveFlnmAF = 'Save_Airfoil.txt';
fidAirfoil = fopen(saveFlnmAF);
dataBuffer = textscan(fidAirfoil,'%f %f','CollectOutput',1,...
    'Delimiter','','HeaderLines',0);
fclose(fidAirfoil);
% delete(saveFlnmAF);

% Separate boundary points
XB = dataBuffer{1}(:,1);
YB = dataBuffer{1}(:,2);
%% READ DATA FILE: LIFT DRAG COEFFICIENT
saveFlnmCl = 'Save_Cl.txt';
fidCl = fopen(saveFlnmCl);
DataBuffer = textscan(fidCl,'%f %f %f %f %f %f %f','HeaderLines',12,...
    'CollectOutput',1,...
    'Delimiter','');
fclose(fidCl);
% delete(saveFlnmCp);

% Separate Cp data
ap  = DataBuffer{1,1}(:,1);
CL  = DataBuffer{1,1}(:,2);
CD = DataBuffer{1,1}(:,3);
CDp = DataBuffer{1,1}(:,4);
CM = DataBuffer{1,1}(:,5);
X_t = DataBuffer{1,1}(:,6);
X_b= DataBuffer{1,1}(:,7);
%% PLOT DATA
% Split airfoil into (U)pper and (L)ower
XB_U = XB(YB >= 0);
XB_L = XB(YB < 0);
YB_U = YB(YB >= 0);
YB_L = YB(YB < 0);

% Split Xfoil results into (U)pper and (L)ower
% Cp_U = Cp_0(YB >= 0);
% Cp_L = Cp_0(YB < 0);
% X_U  = X_0(YB >= 0);
% X_L  = X_0(YB < 0);

% Plot: Airfoil
subplot(2,2,1)
% figure(1);
cla; hold on; grid off;
set(gcf,'Color','k');
set(gca,'Color','k');
set(gca,'XColor','W');
set(gca,'YColor','W');
set(gca,'FontSize',12);
title(['NACA ' NACA ],'color','g','fontsize', 25)
plot(XB_U,YB_U,'b.-');
plot(XB_L,YB_L,'r.-');
str = {['Re = '  re],['Mach = '  ma]};
annotation('textbox', [0.4,0.7,0.3,0.3],'String',str,'color','w','fontsize', 15);
xlabel('X Coordinate');
ylabel('Y Coordinate');
axis equal;

% Plot: Drag Polar
subplot(2,2,2)
% figure(2);
cla; hold on; grid on;
set(gcf,'Color','k');
set(gca,'Color','k');
set(gca,'XColor','W');
set(gca,'YColor','W');
set(gca,'FontSize',12);
title('Drag Polar(Cl vs Cd)','color','g','fontsize', 25)
plot(CD,CL,'r-','LineWidth',2);
ylabel('CL');
xlabel('10^4 * Cd');
ylim('auto');


% Plot: Lift Polar
subplot(2,2,3)
% figure(3);
cla; hold on; grid on;
set(gcf,'Color','k');
set(gca,'Color','k');
set(gca,'XColor','W');
set(gca,'YColor','W');
set(gca,'FontSize',12);
title('Lift Polar(Cl vs alpha)','color','g','fontsize', 25)
plot(ap,CL,'r-','LineWidth',2);
xlabel('Alpha');
ylabel('CL');
ylim('auto');

% Plot: Transition Polar
subplot(2,2,4)
% figure(4);
cla; hold on; grid on;
set(gcf,'Color','k');
set(gca,'Color','k');
set(gca,'XColor','W');
set(gca,'YColor','W');
set(gca,'FontSize',12);
title('Transition Polar','color','g','fontsize', 25)
plot(X_t,CL,'b-','LineWidth',2);
plot(X_b,CL,'r-','LineWidth',2);
legend('Upper', 'Lower','TextColor','w')
xlabel('xtr/C');
ylabel('CL');
ylim('auto');