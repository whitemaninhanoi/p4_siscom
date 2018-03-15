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
   

    ao = (2/T)*int(f,t,-T/2,T/2);
    an = (2/T)*int(f*cos(wo*n*t),t,-T/2,T/2);
    bn = (2/T)*int(f*sin(wo*n*t),t,-T/2,T/2);

    pp = 0;
    aa = 0;
    bb = 0;
    
    a0 = 1/4*(double(ao)^2);
    
    pw = getPTotal(f,T,t);
    fprintf('Potencia total: %f\n', pw);
    
    flag = 0;
    flag2 = 0;
    for i = n
        if (a0+(pp/2)) >= pw*0.5
            flag = flag + 1;
            if flag == 1
                fprintf('Potencia de 3DB [%d armonico] - [%f Hz BW] - %f W\n', i, double((i*frec)-frec), a0+(pp/2)); 
            end
        end
        if (a0+(pp/2)) >= pw*max
            flag2 = flag2 + 1;
            if flag2 == 1
                fprintf('Potencial Maximo [%d armonico] - [%f Hz BW] - %f W\n', i, double((i*frec)-frec), a0+(pp/2)); 
            end
        end
            
%         JP code
        aa = aa + ( an(i)*cos(i*wo*t) );
        bb = bb + ( bn(i)*sin(i*wo*t) );
%         --- end
        pp = pp + (an(i)^2 + bn(i)^2);
    end
    
    power_arm = pp;

    
    
    % Calculate power bandwidth
    % Applying Parseval's principle
%     pp = 0;
%     condition = pw*max;
%     flag = 0;
%     for i = n
%         if (pp + a0) >= condition
%             flag = flag + 1;
%             if flag == 1
%                 fprintf('Potencia al <-armónico [%d][%d rad/s]: %f W\n', i, i*2*pi, a0+(pp/2));
%             end
%         end
%         cn = double((an(i)^2 + bn(i)^2))/2;
%         pp = pp + cn;
%     end
%     
%     double(pp)
    
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