function info = InitDialog(pos,count,rep)
    d = dialog('Position',pos,'Name','HandsOn-Algorithms');
    Nc=7;
    Nm=5;
if count==0 
    instructions(d)
    count=choosecount(d,Nc);
end
mode=choosemode(d,Nm,rep);
info(1)=count;
info(2)=mode;
close(d)
% uiwait(d)
% Wait for d to close before running to completion
end
function instructions(d)
txt(1) = uicontrol('Parent',d,...
    'Style','text',...
    'HorizontalAlignment','left',...
    'Position',[50 150 600 500],...
    'FontSize',16,...
    'String','HandsOn Learning of Algorithms');
txt(2) = uicontrol('Parent',d,...
    'Style','text',...
    'HorizontalAlignment','left',...
    'Position',[50 0 600 500],...
    'FontSize',14,...
    'String',{'This program is designed for user to learn and train sorting algorithms.','', ...
    'Currently, 3 different modes are implemented. These are Free Run, Bubble Sort and Insertion Sort.','',...
    'Free Run: In this mode the user selects the springs, compares them and tries to achieve a sorted group of elements.','', ...
    'Guided Runs: Includes Bubble Sort and Insertion Sort where the user observes the logic behind the order of spring comparisons and makes the spring comparisons.'});
btn = uicontrol('Parent',d,...
    'Position',[500 100 200 50],...
    'String','NEXT -->',...
    'FontSize',16,...
    'Callback',@btn_callback);
drawnow
selected=false;
while ~selected
    drawnow
    %disp(char(btn.String));
    if char(btn.String)=='S'
        selected=true;
    end
end
delete(btn)
delete(txt)
end
function count=choosecount(d,N)
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[250 650 400 50],...
    'HorizontalAlignment','left',...
    'FontSize',16,...
    'String','Choose number of elements');

for i=1:N
    btn(i) = uicontrol('Parent',d,...
        'Position',[300 650-i*60 200 50],...
        'String',num2str(i+2),...
        'FontSize',16,...
        'Callback',@btn_callback);
end
drawnow
count=0;
selected=false;
while ~selected
    drawnow
    for i=1:N
        if btn(i).String=='S'
            selected=true;
            count=i+2;
        end
    end
end
% for i=1:N
%     btn(i).Enable='off';
%     btn(i).Visible='off';
% end
delete(btn);
delete(txt);
end
function mode=choosemode(d,N,rep)
modes={'Free Run','Bubble Sort','Insertion Sort','Merge Sort','End'};
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[300 650 200 50],...
    'FontSize',16,...
    'String','Choose sorting way');

for i=1:N
    btn(i) = uicontrol('Parent',d,...
        'Position',[300 650-i*60 200 50],...
        'String',modes(i),...
        'FontSize',16,...
        'Callback',@btn_callback);
end
if ~rep
    btn(N).Enable='off';
    btn(N).Visible='off';
end
drawnow
mode=0;
selected=false;
while ~selected
    drawnow
    for i=1:N
        %         disp(cbtn(i).String)
        if char(btn(i).String)=='S'
            selected=true;
            mode=i;
        end
    end
end
end
function btn_callback(source,event)
source.String='S';
end
