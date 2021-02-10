clear;
clc;
close;

% User Inputs
NACA       = '4412';
AoA        = '0';
re_1       = '3000000';
re_2       = '1000000';
re_3       = '500000';
ma         = '0.1';
iter       = '250';
% numNodes   = '35';
saveFlnmAF_1 = 'Save_Airfoil_4412_re11.txt';
saveFlnmAF_2 = 'Save_Airfoil_4412_re22.txt';
saveFlnmAF_3 = 'Save_Airfoil_4412_re33.txt';
% saveFlnmCp = 'Save_Cp_0012.txt';
saveFlnmCl_1 = 'Save_Cl_4412_re11.txt';
saveFlnmCl_2 = 'Save_Cl_4412_re22.txt';
saveFlnmCl_3 = 'Save_Cl_4412_re33.txt';

% Delete files if they exist
if (exist(saveFlnmAF_1,'file'))
    delete(saveFlnmAF_1);
end
if (exist(saveFlnmAF_2,'file'))
    delete(saveFlnmAF_2);
end
if (exist(saveFlnmAF_3,'file'))
    delete(saveFlnmAF_3);
end
% if (exist(saveFlnmCp,'file'))
%     delete(saveFlnmCp);
% end
if (exist(saveFlnmCl_1,'file'))
    delete(saveFlnmCl_1);
end
if (exist(saveFlnmCl_2,'file'))
    delete(saveFlnmCl_2);
end
if (exist(saveFlnmCl_3,'file'))
    delete(saveFlnmCl_3);
end

% Create the airfoil
fid = fopen('xfoil_input.txt','w');
fprintf(fid,['NACA ' NACA '\n']);

% Find the Cl vs. Cd plot
fprintf(fid,'OPER\n');
fprintf(fid,['iter ' iter '\n']);
fprintf(fid,'visc\n');
fprintf(fid,'\n');
fprintf(fid,['re ' re_1 '\n']);
fprintf(fid,['m ' ma '\n']);
fprintf(fid,'seqp\n');
fprintf(fid,'pacc\n');
fprintf(fid,[saveFlnmCl_1 '\n\n']);
fprintf(fid,'aseq -20 20 1 \n');
fprintf(fid,'pacc\n\n');

fprintf(fid,'OPER\n');
fprintf(fid,['re ' re_2 '\n']);
fprintf(fid,'pacc\n');
fprintf(fid,[saveFlnmCl_2 '\n\n']);
fprintf(fid,'aseq -20 20 1 \n');
fprintf(fid,'pacc\n\n');

fprintf(fid,'OPER\n');
fprintf(fid,['re ' re_3 '\n']);
fprintf(fid,'pacc\n');
fprintf(fid,[saveFlnmCl_3 '\n\n']);
fprintf(fid,'aseq -20 20 1 \n');

% Close file
fclose(fid);

% Run XFoil using input file
cmd = 'xfoil.exe < xfoil_input.txt';
[status,result] = system(cmd);

%% READ DATA FILE: LIFT DRAG COEFFICIENT
saveFlnmCl_1 = 'Save_Cl_4412_re1.txt';
fidCl_1 = fopen(saveFlnmCl_1);
DataBuffer_1 = textscan(fidCl_1,'%f %f %f %f %f %f %f','HeaderLines',12,...
    'CollectOutput',1,...
    'Delimiter','');
fclose(fidCl_1);
% delete(saveFlnmCp);

% Separate Cp data
ap_1  = DataBuffer_1{1,1}(:,1);
CL_1  = DataBuffer_1{1,1}(:,2);
CD_1 = DataBuffer_1{1,1}(:,3);
CDp_1 = DataBuffer_1{1,1}(:,4);
CM_1 = DataBuffer_1{1,1}(:,5);
X_t_1 = DataBuffer_1{1,1}(:,6);
X_b_1= DataBuffer_1{1,1}(:,7);

saveFlnmCl_2 = 'Save_Cl_4412_re2.txt';
fidCl_2 = fopen(saveFlnmCl_2);
DataBuffer_2 = textscan(fidCl_2,'%f %f %f %f %f %f %f','HeaderLines',12,...
    'CollectOutput',1,...
    'Delimiter','');
fclose(fidCl_2);
% delete(saveFlnmCp);

% Separate Cp data
ap_2  = DataBuffer_2{1,1}(:,1);
CL_2  = DataBuffer_2{1,1}(:,2);
CD_2 = DataBuffer_2{1,1}(:,3);
CDp_2 = DataBuffer_2{1,1}(:,4);
CM_2 = DataBuffer_2{1,1}(:,5);
X_t_2 = DataBuffer_2{1,1}(:,6);
X_b_2= DataBuffer_2{1,1}(:,7);

saveFlnmCl_3 = 'Save_Cl_4412_re3.txt';
fidCl_3 = fopen(saveFlnmCl_3);
DataBuffer_3 = textscan(fidCl_3,'%f %f %f %f %f %f %f','HeaderLines',12,...
    'CollectOutput',1,...
    'Delimiter','');
fclose(fidCl_3);
% delete(saveFlnmCp);

% Separate Cp data
ap_3  = DataBuffer_3{1,1}(:,1);
CL_3  = DataBuffer_3{1,1}(:,2);
CD_3 = DataBuffer_3{1,1}(:,3);
CDp_3 = DataBuffer_3{1,1}(:,4);
CM_3 = DataBuffer_3{1,1}(:,5);
X_t_3 = DataBuffer_3{1,1}(:,6);
X_b_3 = DataBuffer_3{1,1}(:,7);
%% PLOT DATA
% Split airfoil into (U)pper and (L)ower
% XB_U = XB(YB >= 0);
% XB_L = XB(YB < 0);
% YB_U = YB(YB >= 0);
% YB_L = YB(YB < 0);

% Split Xfoil results into (U)pper and (L)ower
% Cp_U = Cp_0(YB >= 0);
% Cp_L = Cp_0(YB < 0);
% X_U  = X_0(YB >= 0);
% X_L  = X_0(YB < 0);

%% CD, CL, ALPHA, TRANSITION POLAR
% Plot: Airfoil
subplot(2,2,1)
% figure(1);
cla; hold on; grid off;
set(gcf,'Color','k');
set(gca,'Color','k');
set(gca,'XColor','W');
set(gca,'YColor','W');
set(gca,'FontSize',12);
% title(['NACA ' NACA ],'color','g','fontsize', 25)
% plot(XB_U,YB_U,'b.-');
% plot(XB_L,YB_L,'r.-');
str_1 = {['NACA ' NACA ' Re = ' re_1 ' Mach = ' ma]};
str_2 = {['NACA ' NACA ' Re = ' re_2 ' Mach = ' ma]};
str_3 = {['NACA ' NACA ' Re = ' re_3 ' Mach = ' ma]};
text(0.1,0.25,str_1,'color','r','fontsize', 15);
text(0.1,0.5,str_2,'color','y','fontsize', 15);
text(0.1,0.75,str_3,'color','m','fontsize', 15);

% xlabel('X Coordinate');
% ylabel('Y Coordinate');
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
set(gca,'GridAlpha',0.9);
set(gca,'GridColor', 'w');
title('Drag Polar(Cl vs Cd)','color','g','fontsize', 25)
plot(CD_1,CL_1,'r-','LineWidth',2);
plot(CD_2,CL_2,'y-','LineWidth',2);
plot(CD_3,CL_3,'m-','LineWidth',2);
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
set(gca,'GridAlpha',0.9);
set(gca,'GridColor', 'w');
title('Lift Polar(Cl vs alpha)','color','g','fontsize', 25)
plot(ap_1,CL_1,'r-','LineWidth',2);
plot(ap_2,CL_2,'y-','LineWidth',2);
plot(ap_3,CL_3,'m-','LineWidth',2);
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
set(gca,'GridAlpha',0.9);
set(gca,'GridColor', 'w');
title('Transition Polar','color','g','fontsize', 25)
plot(X_t_1,CL_1,'r-','LineWidth',2);
plot(X_b_1,CL_1,'r-','LineWidth',2);
plot(X_t_2,CL_2,'y-','LineWidth',2);
plot(X_b_2,CL_2,'y-','LineWidth',2);
plot(X_t_3,CL_3,'m-','LineWidth',2);
plot(X_b_3,CL_3,'m-','LineWidth',2);
% legend('Upper', 'Lower','TextColor','w')
xlabel('xtr/C');
ylabel('CL');
ylim('auto');