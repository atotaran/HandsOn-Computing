function [bpos,rs,brkloop]=selectbox(s,rs,t1,btn,btn2,bpos,sorted,N)
%This function deals with the selection of box during the Free Run mode. It
%also enables breaking of the loop when needed.
brkloop=false;
for b=1:2
    boxslct=false;
    btn.Enable='on';
    btn.Visible='on';
    btn.String='Select';
    rs(b).r.Visible='on';
    tic
    
    t1.String=['Select the ' num2str(b) 'th spring for comparison'];
    while ~boxslct
        bpos=boxupdate(s, bpos);
        if abs(bpos)<0.15
            tic
        end
        if toc>0.5
            incr=sign(bpos);
            if 1 <= rs(b).p +incr && rs(b).p +incr < N+b-1
                if b==2
                    if rs(1).p<rs(b).p+incr
                    xb=rs(b).p;
                    rs=slidebox(xb,rs,b,incr);
                    end
                else
                    xb=rs(b).p;
                    rs=slidebox(xb,rs,b,incr);
                end
            else
            end
            tic
        end
        if btn.String=='1'
            boxslct=true;
            if b==1
                rs(2).p=rs(1).p+1;
                rs(2).r.Position(1)=rs(2).p-0.45;
            end
        end
        if btn2.String=='1'
            if sorted;
                brkloop=true;
                btn2.String='Good job!';
                break;
            else
                btn2.String='Not yet';
            end
        end
        drawnow;
        if brkloop
            break;
        end
    end
end
end

function bpos=boxupdate(s,bpos)
if s.BytesAvailable
    [data, com_error]=serread(s);
    bpos=-1*double(data(2))/600;
end
end

function rs=slidebox(xb,rs,b,incr)
M=20;
for k=1/M:1/M:1;
    xnew=xb*(1-k)+(xb+incr)*k;
    rs(b).p=xnew;
    rs(b).r.Position(1)=xnew-0.45;
    drawnow
end
end