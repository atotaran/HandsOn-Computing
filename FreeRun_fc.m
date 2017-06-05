function CompMatrix=FreeRun_fc(N,ks)
%% Initialization
[p,hndl, rs, sketches,vars, texts]=init(N,ks,0);
[x, xmin, xmax, ymin, ymax, xmid, bwid, psamp, in, ins2, in1, in2]=deal(vars{:});
[C, spring1, spring2, t2c, t3c]=deal(sketches{:});
[sp1l, sp2l, t1, t12, t2, t3, t_it1, t_it2, t_sw1, t_sw2, t_cmp1, t_cmp2]=deal(texts{:});
i=1;
btn = uicontrol('Style', 'pushbutton', 'String','Select',...
    'Position', [730 250 70 70],...
    'Callback', @btnCB);
btn2 = uicontrol('Style', 'pushbutton', 'String','Sorted',...
    'Position', [375 650 100 50],...
    'Callback', @btnCB2);
% Following lines create the hints for bubble and insertion sort on the
% left bottom of the screen
ltr='BI';
for ii=1:2
    cmp_rec(ii)=rectangle('Position',[xmin+0.2 ymin+ii-0.8 0.5 0.5],'FaceColor',[0.2,0.2 0.2],'Curvature',[1 1]);
    cmp_rec(ii).FaceColor(ii)=1;
    cmp_txt(ii)=text(xmin+0.4, ymin+ii-0.5,ltr(ii), 'FontSize', 12);
    compMats{ii}=ComparisonMat(ks,ii);
end
visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,0)
chng=0;
j=1;
com_error=false;
s=s_open('COM2');
%--------------------INITIALIZATIONS OVER -----------------------
bpos=0;%Position of the handle, will be updated by serial
iter=0;
cmp=0;
CompMatrix=zeros(4*N,3);
ksArray=zeros(1,N);
sorted=false;
btn2.Enable='on';
btn2.Visible='on';
%% Loop
while true;
    %% Spring Selection
    btn2.Enable='on';
    btn2.Visible='on';
    serwrite(s,10,10);
    [bpos,rs,brkloop]=selectbox(s,rs,t1,btn,btn2,bpos,sorted,N);
    if brkloop
        visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,4);
        drawnow
        break;
    end
    btn2.String='Sorted';
    btn2.Enable='off';
    btn2.Visible='off';
    
    cmp=cmp+1;
    t_cmp2.String=num2str(cmp);
    sp1=rs(1).p;sp2=rs(2).p;
    CompMatrix(cmp,1:2)=[sp1 sp2];
    spring1.Color=p(sp1).c;
    spring2.Color=p(sp2).c;
    sp1l.String=p(sp1).let;
    sp2l.String=p(sp2).let;
    %Sending the new stiffness values to target
    if p(sp1).ks<p(sp2).ks
        stiff1=10;
        stiff2=30;
    else
        stiff1=30;
        stiff2=10;
    end
    serwrite(s,stiff1,stiff2)
    time=0;
    tic
    moved=false;
    %% Exploration Part
    while time<4
        [bpos, com_error]=handleupdate(hndl, s, bpos);
        t1.String='Move the box and find the softer spring.';
        if bpos < 0;
            in1=linspace(xmin,xmid-bwid/2+bpos,psamp+1);
            spring1.XData=in1;
        else
            in2=linspace(xmax,xmid+bwid/2+bpos,psamp+1);
            spring2.XData=in2;
        end
        if ~moved && bpos < 0.1
            tic
        else
            moved=true;
        end
        drawnow
        time=toc;
    end
    
    rlsd=false;
    tic
    while  ~rlsd
        if abs(bpos)>0.1
            tic
        end
        [bpos, com_error]=handleupdate(hndl, s, bpos);
        if bpos < 0;
            in1=linspace(xmin,xmid-bwid/2+bpos,psamp+1);
            spring1.XData=in1;
        else
            in2=linspace(xmax,xmid+bwid/2+bpos,psamp+1);
            spring2.XData=in2;
        end
        t1.String='Release the handle when you find it.';
        if toc>1
            rlsd=true;
        end
        drawnow
    end
    
    %% Decision Part
    if p(sp1).ks<p(sp2).ks
        rc=-1;
    else
        rc=1;
    end
    choice=false;
    visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,1)
    while ~choice;
        t1.String='Keep or swap the spring positions to';
        t12.Visible='on';
        [bpos, com_error]=handleupdate(hndl, s, bpos);
        if abs(bpos)>1
            if bpos*rc >0
                if rc>0
                    %Swapping the springs
                    p=springswap(p,sp1,sp2,in,hndl, s, bpos);
                    chng=chng+1;
                    t_sw2.String=num2str(chng);
                    CompMatrix(cmp,3)=1;
                else
                    CompMatrix(cmp,3)=0;
                end
                choice=true;
                %visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,2)
            else
                t1.String='Are you sure?';
                t12.Visible='off';
            end
        end
        drawnow
    end
    visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,6)
    rlsd=false;
    tic
    while  ~rlsd
        if abs(bpos)>0.1
            tic
        end
        [bpos, com_error]=handleupdate(hndl, s, bpos);
        if bpos < 0;
            in1=linspace(xmin,xmid-bwid/2+bpos,psamp+1);
            spring1.XData=in1;
        else
            in2=linspace(xmax,xmid+bwid/2+bpos,psamp+1);
            spring2.XData=in2;
        end
        t1.String='Well done! Please release the handle.';
        if toc>1
            rlsd=true;
        end
        drawnow
    end
    if ~sorted
        for ksi=1:N
            ksArray(ksi)=p(ksi).ks;
        end
        sorted=issorted(ksArray);
    end
    for ii=1:2
        if cmp<=length(compMats{ii})
            if CompMatrix(cmp,:)==compMats{ii}(cmp,:)
            else
                cmp_rec(ii).Visible='off';
                cmp_txt(ii).Visible='off';
            end
        else
            cmp_rec(ii).Visible='off';
            cmp_txt(ii).Visible='off';
        end
    end
end
visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,4)
drawnow
%% END
CompMatrix=CompMatrix(1:cmp,:);
t1.String='Sorting is accomplished.';
t12.String='You have completed free run.';
t12.Visible='on';
pause(2.5)
t12.Visible='off';
t1.String='CONGRATULATIONS';
s_close(s)

end