screenpos=[-900, 50, 800, 700];  %When extra screen is on left
% screenpos=[200, 50, 800, 700];

info=InitDialog(screenpos,0,false);
N=info(1);mode=info(2);
% N=4;
% mode=1;
stop=false;
unstrdArr=randperm(N);
i=0;
while ~stop
    ModeDialog(screenpos,mode);
    i=i+1;
    fig1=figure('Position', screenpos);
    switch mode
        case 1
            compMatrix=FreeRun_fc(N,unstrdArr);
        case 2
            compMatrix=bubblesort_fc(N,unstrdArr);
        case 3
            compMatrix=insertionsort_fc(N,unstrdArr);
        case 4
            msgbox('NOT YET IMPLEMENTED')
        otherwise
    end
    tbl(i).md=mode;
    tbl(i).comp=compMatrix;
    close(fig1)
    info=InitDialog(screenpos,N,true);
    mode=info(2);
    if mode==5 
        stop=true;
    end
end

% displayTable(tbl)

%%%%% DIALOG fonksiyonunu deneyebilirsin