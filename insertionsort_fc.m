function CompMatrix=insertionsort_fc(N,ks)
%% Initialization
[p,hndl, rs, sketches,vars, texts]=init(N,ks,5);
[x, xmin, xmax, ymin, ymax, xmid, bwid, psamp, in, ins2, in1, in2]=deal(vars{:});
[C, spring1, spring2, t2c, t3c]=deal(sketches{:});
[sp1l, sp2l, t1, t12, t2, t3, t_it1, t_it2, t_sw1, t_sw2, t_cmp1, t_cmp2]=deal(texts{:});
piv=text(2-0.2,5,'pivot', 'FontSize', 12,'Color','b');

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
%while chng>0 && ~com_error; %The operation finishes once there is no change done in a loop
chng=0;
iter=iter+1;
t_it2.String=num2str(iter);
i=1;
swp=0;
for j=2:N
    k=j;
    slide2newpiv(rs,piv,i+1,k,hndl, s, bpos);
    i=k-1;
    disp(['j= ' num2str(j)])
    rs(1).r.Position=[i-0.45 -0.1 0.9 N+0.2];
    rs(1).r.Visible='on';
    rs(2).r.Position=[i+0.55 -0.1 0.9 N+0.2];
    rs(2).r.Visible='on';
    shiftY(p,rs,k,0.5,hndl, s, bpos);
    while k>1
        cmp=cmp+1;
        t_cmp2.String=num2str(cmp);
        t_sw2.String=num2str(chng);
        disp(['k= ' num2str(k)])
        i=k-1;
        piv.Position=[k-0.2 5];
        rs(1).r.Position(1)=k-1-0.45;
        rs(1).r.Visible='on';
        rs(2).r.Position(1)=k-0.45;
        CompMatrix(cmp,1:2)=[k k-1];
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
        tic
        visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,1)
        while ~choice;
            t1.String='Keep or swap the spring positions to';
            t12.Visible='on';
            [bpos, com_error]=handleupdate(hndl, s, bpos);
            if bpos < 0;
                in1=linspace(xmin,xmid-bwid/2+bpos,psamp+1);
                spring1.XData=in1;
            else
                in2=linspace(xmax,xmid+bwid/2+bpos,psamp+1);
                spring2.XData=in2;
            end
            if abs(bpos)>1
                if bpos*rc >0
                    if rc>0
                        rs(1).r.Visible='off';
                        %Swapping the springs
                        p=springswap_insert(p,rs,piv,i,i+1,in,hndl, s, bpos);
                        chng=chng+1;
                        t_sw2.String=num2str(chng);
                        k=k-1;
                        swp=1;
                        CompMatrix(cmp,3)=1;
                    else
                        k=1;
                        swp=0;
                        CompMatrix(cmp,3)=0;
                    end
                    choice=true;
                    visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,2)
                else
                    t1.String='Are you sure?';
                    t12.Visible='off';
                end
            end
            drawnow
        end
        visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,8)
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
    shiftY(p,rs,i+1-swp,-0.5,hndl,s,bpos);
end
str=['Number of changes in round ' num2str(iter) ' is' num2str(chng)];
disp(str)
%end
%% COM ERROR CHECK
if(com_error)
    disp('HOUSTON, WE HAVE A PROBLEM')
else
    disp('THIS IS THE END')
end
%% END
CompMatrix=CompMatrix(1:cmp,:);
visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,5)
t1.String='Pivot is position has reached the end';
t12.String='which means that sorting is successful.';
t12.Visible='on';
piv.Visible='off';
pause(2.5)
t12.Visible='off';
t1.String='CONGRATULATIONS';
s_close(s)
end
