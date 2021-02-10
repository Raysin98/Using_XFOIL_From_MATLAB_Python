clear;
clc;
close;

NACA       = '4412';
re         = '0';
ma         = '0';
AoA        = '10';
numNodes   = '35';
saveFlnmAF = 'Save_Airfoil.txt';
saveFlnmCp = 'Save_Cp.txt';

% Delete files if they exist
if (exist(saveFlnmAF,'file'))
    delete(saveFlnmAF);
end
if (exist(saveFlnmCp,'file'))
    delete(saveFlnmCp);
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
fprintf(fid,['Alfa ' AoA '\n']);
fprintf(fid,['CPWR ' saveFlnmCp]);

% Close file
fclose(fid);

% Run XFoil using input file
cmd = 'xfoil.exe < xfoil_input.txt';
[status,result] = system(cmd);
%% READ DATA FILE: AIRFOIL
saveFlnmAF = 'Save_Airfoil.txt';
fidAirfoil = fopen(saveFlnmAF);
dataBuffer = textscan(fidAirfoil,'%f %f','CollectOutput',0,...
    'Delimiter','','HeaderLines',0);
fclose(fidAirfoil);
% delete(saveFlnmAF);

% Separate boundary points
XB = dataBuffer{1}(:,1);
YB = dataBuffer{1}(:,2);
%% READ DATA FILE: PRESSURE COEFFICIENT
saveFlnmCp = 'Save_Cp.txt';
fidCP = fopen(saveFlnmCp);
dataBuffer = textscan(fidCP,'%f %f %f','HeaderLines',3,...
    'CollectOutput',1,...
    'Delimiter','');
fclose(fidCP);
% delete(saveFlnmCp);

% Separate Cp data
X_0  = dataBuffer{1,1}(:,1);
Y_0  = dataBuffer{1,1}(:,2);
Cp_0 = dataBuffer{1,1}(:,3);
%% PLOT DATA
% Split airfoil into (U)pper and (L)ower
XB_U = XB(YB >= 0);
XB_L = XB(YB < 0);
YB_U = YB(YB >= 0);
YB_L = YB(YB < 0);
% Split Xfoil results into (U)pper and (L)ower
Cp_U = Cp_0(YB >= 0);
Cp_L = Cp_0(YB < 0);
X_U  = X_0(YB >= 0);
X_L  = X_0(YB < 0);

% Plot: Airfoil
% figure(1);
subplot(2,1,2)
cla; hold on; grid off;
set(gcf,'Color','k');
set(gca,'Color','k');
set(gca,'XColor','W');
set(gca,'YColor','W');
set(gca,'FontSize',12);
title(['NACA ' NACA ],'color','g')
str = {['Alpha = '  AoA],['Re = '  re],['Mach = '  ma]};
annotation('textbox', [0.7,0.15,0.3,0.3],'String',str,'color','w')               
plot(XB_U,YB_U,'b.-');
plot(XB_L,YB_L,'r.-');
xlabel('X Coordinate');
ylabel('Y Coordinate');
axis equal;

% Plot: Pressure coefficient
% figure(2);
subplot(2,1,1)
cla; hold on; grid on;
set(gcf,'Color','k');
set(gca,'Color','k');
set(gca,'XColor','W');
set(gca,'YColor','W');
set(gca,'FontSize',12);
title('Cp Polar','color','g')
% str1 = ['Alpha = '  AoA ' Re = '  re ' Mach = '  ma];
% annotation('textbox', [0.5,0.7,0.3,0.3],'String',str1,'color','w')
plot(X_U,Cp_U,'bo-','LineWidth',2);
plot(X_L,Cp_L,'ro-','LineWidth',2);
legend('Upper', 'Lower','TextColor','w')
xlabel('X/C');
ylabel('Cp');
ylim('auto');
set(gca,'Ydir','reverse')