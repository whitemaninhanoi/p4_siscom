function execute( type, arm )

    syms t

    frec = 50000;
    T = 1/frec;
    wo = 2*pi*frec;
    Am=0.3;
    n = 1:arm;

    if type == 00
      % Sine
      f = sin(wo*t);
    elseif type == 01
      % Square
      f = heaviside(-t); %pulso rectangular
    elseif type == 10
      % Tri
      f = t;
    elseif type == 11
      % Other
      f = sin(wo*t) + sin((wo/3)*t+15);
    end

    figure(1)
    ezplot(f,[-T/2 T/2])

    ao = (2/T)*int(f,t,-T/2,T/2);
    an = (2/T)*int(f*cos(wo*n*t),t,-T/2,T/2);
    bn = (2/T)*int(f*sin(wo*n*t),t,-T/2,T/2);

    ph = abs(getPolar(t,T,wo,f,n));
    pp = 0;
    aa = 0;
    bb = 0;

    for i = n
       aa = aa + ( an(i)*cos(i*wo*t) );
       bb = bb + ( bn(i)*sin(i*wo*t) );
       pp = pp + (2*(ph(i)^2));
    end

    pw = getPTotal(f,T,t);
    fprintf('Potencia total: %f\n', pw);

    parm = double(pp);
    fprintf('Potencia al armonico %f = %f\n', arm, parm);

    per = getPercentage(parm,pw);
    fprintf('Porcentaje de potencia = %f\n', per);

    ff= (ao/2) + aa + bb;

    figure(2)
    ezplot(ff,[0 4*T])

    figure(3)
    stem(abs(double(an) + double(bn) ))

end

function per = getPercentage(parm,pw)

  % Porcentaje de la potencia
  per=(parm*100)/pw;

end

function pw = getPTotal(f,T,t)

  % Potencia Total
  pw = double((1/T)*int((f^2),t,-T/2,T/2));

end

function polar = getPolar(t,T,wo,f,n)

  % Serie polar
  polar = (1/T)*int(f*exp(-j*n*wo*t),t,-T/2,T/2);

end
