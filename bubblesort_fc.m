function CompMatrix=bubblesort_fc(N,ks)
%% Initialization
[p,hndl,rs, sketches,vars, texts]=init(N,ks,5);
[x, xmin, xmax, ymin, ymax, xmid, bwid, psamp, in, ins2, in1, in2]=deal(vars{:});
[C, spring1, spring2, t2c, t3c]=deal(sketches{:});
[sp1l, sp2l, t1, t12, t2, t3, t_it1, t_it2, t_sw1, t_sw2, t_cmp1, t_cmp2]=deal(texts{:});

visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,0,N,0)
chng=100;
j=0;
com_error=false;
s=s_open('COM2');
%---------------------INITIALIZATIONS OVER -----------------------
bpos=0;%Iterated values
iter=0;
cmp=0;
CompMatrix=zeros(N*4,3);
%% Loop
N2=N;
while N2>0 && ~com_error; %The operation finishes once there is no change done in a loop
    chng=0;
    newN2=0;
    iter=iter+1;
    t_it2.String=num2str(iter);
    for i=1:N2-1
        cmp=cmp+1;
        t_cmp2.String=num2str(cmp);
        t_sw2.String=num2str(chng);
        rs(1).r.Position=[i-0.45 -0.1 0.9 N+0.2];
        rs(1).r.Visible='on';
        rs(2).r.Position=[i+0.55 -0.1 0.9 N+0.2];
        rs(2).r.Visible='on';
        CompMatrix(cmp,1:2)=[i i+1];
        spring1.Color=p(i).c;
        spring2.Color=p(i+1).c;
        sp1l.String=p(i).let;
        sp2l.String=p(i+1).let;
        %Sending the new stiffness values to target
        if p(i).ks<p(i+1).ks
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
        if p(i).ks<p(i+1).ks
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
                        p=springswap(p,i,i+1,in,hndl, s, bpos);
                        chng=chng+1;
                        t_sw2.String=num2str(chng);
                        newN2=i;
                        CompMatrix(cmp,3)=1;
                    else
                        CompMatrix(cmp,3)=0;
                    end
                    choice=true;
                    visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,2)
                    %                     p(i).s.Color='b';
                    %                     p(i+1).s.Color='b';
                else
                    t1.String='Are you sure?';
                    t12.Visible='off';
                end
            end
            drawnow
        end
        
        visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,3)
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
        visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,4)
        drawnow
    end
    %% Question Part
    
    if N2==N
        serwrite(s,10,10)
        choice=false;
        visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,1)
        t2.String='Yes';
        t3.String='No';
        while ~choice;
            t1.String='Should the rightmost spring be ';
            t12.String='the stiffest now?';
            t12.Visible='on';
            [bpos, com_error]=handleupdate(hndl, s, bpos);
            if bpos >1
                t1.String='Are you sure?';
                t12.Visible='off';
            elseif bpos <-1
                choice=true;
            end
            drawnow
        end
    end
    visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,N2,N,7)
    t2.String='Keep';
    t3.String='Swap';
    %% 
    for ch=newN2+1:N2
    p(ch).chk.Visible='on';
    end
    N2=newN2;
    disp(['N2: ' num2str(N2)]);
%     N2=N2-1;
    N2=newN2;
    str=['Number of changes in round ' num2str(iter) ' is ' num2str(chng)];
    disp(str)
end

if(com_error)
    disp('HOUSTON, WE HAVE A PROBLEM')
else
    disp('THIS IS THE END')
end
visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,5)
%% END
CompMatrix=CompMatrix(1:cmp,:);
t1.String='Sorting requirements are met.';
% t12.String='which means that sorting is successful.';
% t12.Visible='on';
pause(2.5)
% t12.Visible='off';
t1.String='CONGRATULATIONS';
s_close(s)
end