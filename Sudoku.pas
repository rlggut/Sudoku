type rec=record//алфавит замены
  num:array [1..9] of integer;
  constructor Create();
  var i:integer;
  begin
    for i:=1 to 9 do
      num[i]:=i;
  end;
  procedure rand();//случайный обмен двух чисел в алфавите
  var i,j,k:integer;
  begin
    i:=random(1,9);
    j:=i;
    while(i=j) do j:=random(1,9);
    k:=num[i];
    num[i]:=num[j];
    num[j]:=k;
  end;
  procedure wr();//вывод алфавита на экран
  var i:integer;
  begin
    for i:=1 to 9 do
      write(num[i]+' ');
    writeln;
  end;
end;

type sudoku=record//таблица судоку
  num:array [1..9] of array [1..9] of integer;
  constructor Create();//ряд от 1 до 9 сдвинутый циклично так, чтобы таблица соответствовала правилам судоку
  begin
    num[1][1]:=1; num[1][2]:=2; num[1][3]:=3; num[1][4]:=4; num[1][5]:=5; num[1][6]:=6; num[1][7]:=7; num[1][8]:=8; num[1][9]:=9;
    num[2][1]:=4; num[2][2]:=5; num[2][3]:=6; num[2][4]:=7; num[2][5]:=8; num[2][6]:=9; num[2][7]:=1; num[2][8]:=2; num[2][9]:=3;
    num[3][1]:=7; num[3][2]:=8; num[3][3]:=9; num[3][4]:=1; num[3][5]:=2; num[3][6]:=3; num[3][7]:=4; num[3][8]:=5; num[3][9]:=6;
    num[4][1]:=2; num[4][2]:=3; num[4][3]:=4; num[4][4]:=5; num[4][5]:=6; num[4][6]:=7; num[4][7]:=8; num[4][8]:=9; num[4][9]:=1;
    num[5][1]:=5; num[5][2]:=6; num[5][3]:=7; num[5][4]:=8; num[5][5]:=9; num[5][6]:=1; num[5][7]:=2; num[5][8]:=3; num[5][9]:=4;
    num[6][1]:=8; num[6][2]:=9; num[6][3]:=1; num[6][4]:=2; num[6][5]:=3; num[6][6]:=4; num[6][7]:=5; num[6][8]:=6; num[6][9]:=7;
    num[7][1]:=3; num[7][2]:=4; num[7][3]:=5; num[7][4]:=6; num[7][5]:=7; num[7][6]:=8; num[7][7]:=9; num[7][8]:=1; num[7][9]:=2;
    num[8][1]:=6; num[8][2]:=7; num[8][3]:=8; num[8][4]:=9; num[8][5]:=1; num[8][6]:=2; num[8][7]:=3; num[8][8]:=4; num[8][9]:=5;
    num[9][1]:=9; num[9][2]:=1; num[9][3]:=2; num[9][4]:=3; num[9][5]:=4; num[9][6]:=5; num[9][7]:=6; num[9][8]:=7; num[9][9]:=8;
  end;
  procedure change(alf:rec);//алфавитная замена
  var i,j:integer;
  begin
    for i:=1 to 9 do
      for j:=1 to 9 do
        num[i][j]:=alf.num[(num[i][j])];
  end;
  procedure swip_row();//обмен рядами
  var i,j,k,r:integer;
  begin
    i:=random(1,9);
    j:=i;
    while(j=i) do j:=random(3*((i-1+3)div 3-1)+1,3*((i-1+3)div 3-1)+3);
    for r:=1 to 9 do
    begin
      k:=num[i][r];
      num[i][r]:=num[j][r];
      num[j][r]:=k;
    end;
  end;
  procedure swip_line();//обмен столбцами
  var i,j,k,r:integer;
  begin
    i:=random(1,9);
    j:=i;
    while(j=i) do j:=random(3*((i-1+3)div 3-1)+1,3*((i-1+3)div 3-1)+3);
    for r:=1 to 9 do
    begin
      k:=num[r][i];
      num[r][i]:=num[r][j];
      num[r][j]:=k;
    end;
  end;
  procedure wr();//вывод на экран
  var i,j:integer;
  begin
    for i:=1 to 9 do
    begin
      for j:=1 to 9 do
        write(num[i][j],' ');
      writeln;
    end;
    writeln;
  end;
end;

function compl(s1,s2:rec):boolean;//сравнение двух алфавитов(равны ли они между собой)
var i:integer; flag:boolean;
begin
  flag:=true;
  for i:=1 to 9 do
    if(s1.num[i]<>s2.num[i])then flag:=false;
   compl:=flag;
end;
function compl(s1,s2:sudoku):boolean;//сравнение двух таблиц судоку
var i,j:integer; flag:boolean;
begin
  flag:=true;
  for i:=1 to 9 do
    for j:=1 to 9 do
      if(s1.num[i][j]<>s2.num[i][j])then flag:=false;
  compl:=flag;
end;

var
  a:rec;
  nw,was:sudoku;
  i:integer;
  t,n:integer;
  cor:integer;
begin
//Расчет вероятности совпадения судоку после замены алфавита и исходного варианта
  cor:=0;
  for t:=1 to 1000000 do
  begin
    nw:=new sudoku();
    was:=new sudoku();
    a:=new rec();

    //Общее замечание. При нечетном количестве перестановок, исходная ситуация невозможна
    //за 6 перестановок можно перемешать все тройки столбцов/строк
    for i:=1 to 6 do nw.swip_row();//6*3 вариантов
    for i:=1 to 6 do nw.swip_line();//6*3 вариантов
    //за 8 парных перестановок можно получить любую комбинацию из 9 цифр.
    for i:=1 to 8 do a.rand();//9! вариантов
    //Оценочное количество вариантов 117 573 120

    nw.change(a);
    if(compl(nw,was)) then cor:=cor+1;
  end;
  writeln((cor/1000000)*100,'%');
  nw.wr();
end.