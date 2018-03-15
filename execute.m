function execute( type, arm, max )

    syms t

    frec = 50000;
    T = 1/frec;
    wo = 2*pi*frec;
    Am=0.3;
    n = 1:arm;

    if type == 00
      % Sine
      f = Am/2 * sin(wo*t);
    elseif type == 01
      % Square
      f = Am/2 * heaviside(-t); %pulso rectangular
    elseif type == 10
      % Tri
      f = Am/2 * t;
    elseif type == 11
      % Other
      f = Am/2 * sin(wo*t) + Am/2 * sin((wo/3)*t+15);
    end

    figure(1)
    ezplot(f,[-T/2 T/2])
   

    ao = (1/T)*int(f,t,-T/2,T/2);
    an = (2/T)*int(f*cos(wo*n*t),t,-T/2,T/2);
    bn = (2/T)*int(f*sin(wo*n*t),t,-T/2,T/2);

    pp = 0;
    aa = 0;
    bb = 0;
    
    a0 = 1/4*(double(ao)^2);
    
    pw = getPTotal(f,T,t);
    fprintf('Potencia total: %f\n', pw);

    for i = n
        if pp >= pw*max
            fprintf('Potencia al ->armónico [%d][%d rad/s]: %f W\n', i, i*2*pi, pp + a0);
           break 
        end
%         JP code
        aa = aa + ( an(i)*cos(i*wo*t) );
        bb = bb + ( bn(i)*sin(i*wo*t) );
%         --- end
        pp = pp + ((double(an(i))^2 + double(bn(i))^2)/2);
    end
    
    power_arm = pp;

    
    
    % Calculate power bandwidth
    % Applying Parseval's principle
%     ttp = 1/4*(double(ao)^2);
%     condition = pw*max;
%     count = 1;
%     while 1
%         if 1/2*ttp >= condition
%             fprintf('Potencia al armónico [%d][%d rad/s]: %f W\n', count, count*2*pi, ttp/2);
%             break
%         end
%         a_n = double((2/T)*int(f*cos(wo*count*t),t,-T/2,T/2));
%         b_n = double((2/T)*int(f*sin(wo*count*t),t,-T/2,T/2));
%         temp = a_n^2 + b_n^2;
%         ttp = ttp + temp;
%         count = count + 1;
%     end    
    
    parm = double(power_arm);
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