function [p, hndl, rs, sketches ,vars, texts]=init(N,ks,vis)
x=1:N;
%% Initial parameters
xmin=-1.5;
xmax=N+2;
ymin=-1;
ymax=N+6;
xmid=(xmin+xmax)/2;
bwid=1;

psamp=64; % number of samples for creation of the spring
in=0:psamp;
C = imread('mass_image.jpg'); % The masses to be placed on springs
Check = imread('checksign.jpg');
%Vertical springs
ins2=linspace(0,N,psamp+1);

%% Setting the elements to be sorted as springs(Vertical)
for i=1:N
    p(i).ks=ks(i);
    p(i).y=N-(N-1)/ks(i);
    p(i).c=[abs(0.5-i/N)*1.5 i/N 1-i/N];
    p(i).in=linspace(0,p(i).y,psamp+1);
    ins1=linspace(0,p(i).y,psamp+1);
    p(i).s=plot(i+sin(in*pi/2)/2.5,ins1,'Color',p(i).c,'Linewidth',1.5);
    hold on
    p(i).m=image([i-0.4 i+0.4],[p(i).y+1 p(i).y],C);
    p(i).s2=plot(i+sin(in*pi/2)/2.5,ins2,'Color',p(i).c,'Linewidth',1.5,'Visible','off');
    p(i).chk=image([i-0.3 i+0.3],[-0.5 -0.9],Check,'Visible','off');
    p(i).let=char('A'+i-1);
    p(i).l=text(i-0.08,-0.4,p(i).let,'FontSize', 16);
end

%% -----Handle-----
hndl(1).x=[0 15 15 30 30 45]/15+xmid-1.5*bwid*ones(1,6);
h1py=[0 10 35 35 10 0]/15+ymax-4.5*ones(1,6);
hndl(2).x=[17.5 12.5 10 10]/15+[xmid-1.5*bwid ymax-4.5 0 0];
hndl(3).x=[15 27 15 8]/15+[xmid-1.5*bwid ymax-4.5 0 0];
hndl(1).s=fill(hndl(1).x,h1py,0.85*ones(1,3));
hndl(2).s=rectangle('Position',hndl(2).x,'FaceColor','w','Curvature',[1 1]);
hndl(3).s=rectangle('Position',hndl(3).x,'FaceColor',0.95*ones(1,3));

%% -----Horizontal Springs-----
in1=linspace(xmin,xmid-bwid/2,psamp+1);
in2=linspace(xmax,xmid+bwid/2,psamp+1);
spring1=plot(in1,ymax-3+sin(in*pi/2)/2,'Color',p(1).c,'Linewidth',1.5);
spring2=plot(in2,ymax-3+sin(in*pi/2)/2,'Color',p(2).c,'Linewidth',1.5);
sp1l=text(xmin+0.5,ymax-4,p(1).let,'FontSize',16);
sp2l=text(xmax-0.55,ymax-4,p(2).let,'FontSize',16);


%% -----Texts------
t2c=rectangle('Position',[xmid-2.1 ymax-3.5 0.5+0.07*N 1],'FaceColor','r','Curvature',[1 1],'Visible','off');
t3c=rectangle('Position',[xmid+1.45 ymax-3.5 0.5+0.07*N 1],'FaceColor','b','Curvature',[1 1],'Visible','off');

t1=text(-0.5,ymax-1,'Application starting soon...', 'FontSize', 16);
t12=text(-0.5,ymax-1.6,'place the softer spring on the left side.', 'FontSize', 16,'Visible','off');
t2=text(xmid-2,ymax-3,'Keep', 'FontSize', 16,'Visible','off');
t3=text(xmid+1.5,ymax-3,'Swap', 'FontSize', 16,'Visible','off');
% t_it1=text(xmax-1.5,ymax-0.4,'Iteration no:', 'FontSize', 12,'Units','normalized');
% t_it2=text(xmax-0.2,ymax-0.4,num2str(0), 'FontSize', 12);
% t_sw1=text(xmax-1.5,ymax-0.8,'Swap count:', 'FontSize', 12);
% t_sw2=text(xmax-0.2,ymax-0.8,num2str(0), 'FontSize', 12);
% t_cmp1=text(xmax-1.5,ymax-1.2,'Comparisons:', 'FontSize', 12);
% t_cmp2=text(xmax-0.2,ymax-1.2,num2str(0), 'FontSize', 12);
t_it1=text(0.8,0.97,'Iteration no:', 'FontSize', 12,'Units','normalized');
t_it2=text(0.96,0.97,num2str(0), 'FontSize', 12,'Units','normalized');
t_sw1=text(0.8,0.94,'Swap count:', 'FontSize', 12,'Units','normalized');
t_sw2=text(0.96,0.94,num2str(0), 'FontSize', 12,'Units','normalized');
t_cmp1=text(0.8,0.91,'Comparisons:', 'FontSize', 12,'Units','normalized');
t_cmp2=text(0.96,0.91,num2str(0), 'FontSize', 12,'Units','normalized');
axis([xmin xmax ymin ymax])
%% Comparison boxes
rs(1).p=1;
rs(2).p=2;
rs(1).r=rectangle('Position',[0.55 -0.1 0.9 N+0.2],'EdgeColor','r','Visible','off','Linewidth',3);
rs(2).r=rectangle('Position',[0.55 -0.1 0.9 N+0.2],'EdgeColor','b','Visible','off','Linewidth',3);
visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,vis)
% for jj=1:2
%     t1.String=['Application starting in ' num2str(4-jj) 's'];
%     pause(1)
% end
% visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,0)
%%
vars={x xmin xmax ymin ymax xmid bwid psamp in ins2 in1 in2};
sketches={C spring1 spring2 t2c t3c};
texts={sp1l sp2l t1 t12 t2 t3 t_it1 t_it2 t_sw1 t_sw2 t_cmp1 t_cmp2};
