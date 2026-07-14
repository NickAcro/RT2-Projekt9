function Flugroute(x_out,h_out,theta_out)

%% Daten aus Simulink lesen

x = x_out.signals.values(:);
h = h_out.signals.values(:);
theta = theta_out.signals.values(:);

%% Einstellungen

figure('Color','w','Position',[100 100 1200 800]);
hold on
grid on
box on
axis equal

xlabel('x [m]')
ylabel('h [m]')
title('2D Flugbahn')

%% Flugbahn zeichnen

plot(x,h,'b','LineWidth',2)

%% Boden

yline(0,'k--','Ausgangshöhe')

%% Flugzeuge zeichnen

N = 14;                     % Anzahl Flugzeuge

idx = round(linspace(1,length(x),N));

for i = idx

    drawAircraft2D(x(i),h(i),theta(i),4);

end

%% Achsen automatisch

margin = 20;

xlim([min(x)-margin max(x)+margin])
ylim([min(h)-margin max(h)+margin])

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawAircraft2D(xc,hc,theta,scale)

%% Flugzeuggeometrie

fuselage = [

-2.0  0.0
 2.5  0.0
 2.2  0.15
-1.5  0.15
-2.0  0.0

];

wing = [

-0.6+1 0.05
 0.6-1 0.75
 0.9-1 0.75
 0.0+1 0.05
-0.6+1 0.05

];

tail = [

-1.6+0.2 0.05
-1.2-1+0.2 0.35
-1.4-1 0.35
-1.8 0.05
-1.6 0.05

];

%% Skalieren

fuselage = fuselage*scale;
wing     = wing*scale;
tail     = tail*scale;



%% Rotation

R = [

cos(theta) -sin(theta)

sin(theta)  cos(theta)

];

fuselage = (R*fuselage')';
wing     = (R*wing')';
tail     = (R*tail')';

%% Verschieben

fuselage(:,1)=fuselage(:,1)+xc;
fuselage(:,2)=fuselage(:,2)+hc;

wing(:,1)=wing(:,1)+xc;
wing(:,2)=wing(:,2)+hc;

tail(:,1)=tail(:,1)+xc;
tail(:,2)=tail(:,2)+hc;

%% Zeichnen

patch(fuselage(:,1),fuselage(:,2),...
    [0.85 0.1 0.1],...
    'EdgeColor','k',...
    'LineWidth',1.5);

patch(wing(:,1),wing(:,2),...
    [0.2 0.2 0.9],...
    'EdgeColor','k',...
    'LineWidth',1);

patch(tail(:,1),tail(:,2),...
    [0.2 0.8 0.2],...
    'EdgeColor','k',...
    'LineWidth',1);

end