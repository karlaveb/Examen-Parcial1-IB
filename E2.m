Archivito = 'SeñalRuido.xlsx'; 
X = xlsread(Archivito);

% Parámetros.
fs = 1000;

% FFT de la señal.
N = length(X); 
t = (0:N-1) / fs; 
frequencies = (0:N-1) * (fs / N); 
X_fft = fft(X);
amplitude = abs(X_fft);
phase = angle(X_fft);

% Filtramos la señal.
FC = 5; 
corte = round(FC / (fs / N));
Xf = X_fft;
Xf(corte+1:end-corte) = 0;

% Obtenemos la señal filtrada en el tiempo.
XF = ifft(Xf);

% Frecuencias de 1 Hz y 2 Hz.
f1 = 1;
f2 = 2;

% Obtener los componentes de frecuencia.
c1 = amplitude(f1+1) * exp(1i * phase(f1 + 1));
c2 = amplitude(f2+1) * exp(1i * phase(f2 + 1));

% Graficamos.
figure;
subplot(4, 1, 1);
plot((0:N-1) / fs, X);
title('Señal Original con Ruido');
xlabel('Tiempo [s]');
ylabel('Amplitud');

subplot(4, 1, 2);
plot((0:N-1) / fs, XF);
title('Señal Filtrada');
xlabel('Tiempo [s]');
ylabel('Amplitud');

figure;
subplot(4, 1, 4);
stem(frequencies, amplitude);
xlim([0, 10]);
title('Espectro de Frecuencias');
xlabel('Frecuencia');


FD = [1, 2]; 
S = zeros(2, N);

for i = 1:2 
    f1 = FD(i);
    
    % Calculamos la FFT inversa.
    xf = ifft(X_fft .* (abs(frequencies-f1)<0.5));
    S(i, :) = xf;
    
    % Calculamos la potencia.
    P = sum(abs(xf).^2);
    
    % Graficamos.
    figure;
    subplot(2, 1, 1);
    plot(t, real(xf));
    title(['Señal en el tiempo (', num2str(f1), ' Hz)']);
    xlabel('Tiempo [s]');
    ylabel('Amplitud');
    
    subplot(2, 1, 2);
    bar(1, P);
    title(['Señal en potencias de (', num2str(f1), ' Hz)']);
    xlabel('Señales de interés');
    ylabel('Potencia');
end

% Convolución de las señales.
C = conv(S(1, :), S(2, :));


% Gráficamos.
figure;
subplot(3, 1, 1);
plot(t, real(S(1, :)));
title('Señal de 1 Hz en el tiempo');
xlabel('Tiempo [s]');
ylabel('Amplitud');

subplot(3, 1, 2);
plot(t, real(S(2, :)));
title('Señal de 2 Hz en el tiempo');
xlabel('Tiempo [s]');
ylabel('Amplitud');

subplot(3, 1, 3);
conv_time = (0:length(C)-1) / fs;
plot(conv_time, C);
title('Convolución de las señales');
xlabel('Tiempo [s]');
ylabel('Amplitud');
