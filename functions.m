% Prana Gusriana
% 13519195

% Fungsi untuk menghitung frekuensi untuk setiap nilai keabuan dari suatu
% gambar. Input gambar dapat berupa grayscale format ataupun RGB format.
% Jika ingin mengekstrak frekuensi untuk masing-masing channels gambar,
% input Img perlu diekstrak terlebih dahulu.
function freq = getFreq(Img)
% Definisi nilai keabuan maksimal (256)
N = 256;
% Inisiasi output freq dengan 0 untuk setiap nilai keabuan 0...N-1
freq = zeros(1, N);
for idx = 1:numel(Img)
    % Untuk setiap pixel dari image tambahkan nilai 1 pada output freq yang
    % bersesuaian
    freq(Img(idx) + 1) = freq(Img(idx) + 1) + 1;
end
end
 % Fungsi yang meniru fungsi imhist, tinggal hitung frekuensinya kemudian
 % tampilkan plot bar dari frekuensi tersebut
function imHist(Img)
freq = getFreq(Img);
bar(freq);
end

% Fungsi untuk mencerahkan gambar
function Img = image_brightening(Img, a, b)
% s = ar + b
N = 256;
s = zeros(1, N);
% Untuk setiap nilai keabuan 0...N-1 petakan nilai keabuan tersebut dengan
% rumus s = ar + b, jika nilainya lebih dari nilai keabuan maksimal maka
% set menjadi N-1 dan jika kurang dari nilai keabuan minimum maka set
% menjadi 0
for i = 1:N
    s_temp = a * (i - 1) + b;
    if s_temp > N - 1
        s(i) = N - 1;
    elseif s_temp < 0
        s(i) = 0;
    else
        s(i) = s_temp;
    end
end
% Transform nilai pixel sesuai dengan hasil pemetaan r ke s
for idx = 1:numel(Img)
    Img(idx) = s(Img(idx) + 1);
end
end

% Fungsi log transformation
function Img = log_transformation(Img, c)
% s = c * log (1 + r)
N = 256;
s = zeros(1, N);
% Untuk setiap nilai keabuan 0...N-1 petakan nilai keabuan tersebut dengan
% rumus s = c * log(1 + r), jika nilainya lebih dari nilai keabuan maksimal maka
% set menjadi N-1 dan jika kurang dari nilai keabuan minimum maka set
% menjadi 0
for i = 1:N
    % Karena indexnya dimulai dari 1 jadi i nya perlu dikurang 1
    % s = c * log10(1 + (i -1)) = c * log10(i)
    s_temp = c * log10(i);
    if s_temp > N - 1
        s(i) = N - 1;
    elseif s_temp < 0
        s(i) = 0;
    else
        s(i) = s_temp;
    end
end
% Transform nilai pixel sesuai dengan hasil pemetaan r ke s
for idx = 1:numel(Img)
    Img(idx) = s(Img(idx) + 1);
end
end

% Fungsi power transformation
function Img = power_transformation(Img, c, gamma)
% s = c * r ^ gamma
N = 256;
s = zeros(1, N);
% Untuk setiap nilai keabuan 0...N-1 petakan nilai keabuan tersebut dengan
% rumus s = c * r ^ gamma, jika nilainya lebih dari nilai keabuan maksimal maka
% set menjadi N-1 dan jika kurang dari nilai keabuan minimum maka set
% menjadi 0
for i = 1:N
    s_temp = c * (i - 1) ^ gamma;
    if s_temp > N - 1
        s(i) = N - 1;
    elseif s_temp < 0
        s(i) = 0;
    else
        s(i) = s_temp;
    end
end
% Transform nilai pixel sesuai dengan hasil pemetaan r ke s
for idx = 1:numel(Img)
    Img(idx) = s(Img(idx) + 1);
end
end

% Fungsi untuk meregangkan kontras
function Img = contrast_streching(Img)
% s = (r - rmin) * ((N - 1) / (rmax - rmin))
N = 256;
% Pencarian rmax dan rmin secara otomatis
rmax = max(Img, [], 'all');
rmin = min(Img, [], 'all');
s = zeros(1, N);
% Untuk setiap nilai keabuan 0...N-1 petakan nilai keabuan tersebut dengan
% rumus s = (r - rmin) * ((N - 1) / (rmax - rmin)), jika nilainya lebih dari nilai keabuan maksimal maka
% set menjadi N-1 dan jika kurang dari nilai keabuan minimum maka set
% menjadi 0
for i = 1:N
    s_temp = (i - 1 - rmin) * ((N - 1)/ (rmax - rmin));
    if s_temp > N - 1
        s(i) = N - 1;
    elseif s_temp < 0
        s(i) = 0;
    else
        s(i) = s_temp;
    end
end
% Transform nilai pixel sesuai dengan hasil pemetaan r ke s
for idx = 1:numel(Img)
    Img(idx) = s(Img(idx) + 1);
end
end

% Fungsi histogram equalization transformer digunakan untuk mendapatkan
% nilai hasil pemetaan r ke s
function s = histogram_equalization_transformer(Img)
N = 256;
% Dapatkan frekuensi
freq = getFreq(Img);
n = numel(Img);
% Normalisasikan frekuensi tersebut dengan total seluruh elemen dari Img
norm_freq = freq / n;
% Dapatkan kumulatif dari norm freq
s = zeros(1, N);
s(1) = norm_freq(1);
for i = 2:N 
    s(i) = norm_freq(i) + s(i-1);
end
% Kalikan hasil kumulatif tersebut dengan nilai keabuan maksimal
s = s * (N - 1);
end

% Fungsi histogram equalization berguna untuk menghasilkan output gambar
% hasil proses histogram equalization
function Img = histogram_equalization(Img)
% Dapatkan pemetaan r menjadi s
s = histogram_equalization_transformer(Img);
% Ubah setiap nilai di Img dengan hasil pemetaan s
for idx = 1:numel(Img)
    Img(idx) = s(Img(idx) + 1);
end
end

% Fungsi histogram specification
function Img = histogram_specification(Img, Img_referensi)
% Dapatkan pemetaan histogram equalization dari citra input
s = histogram_equalization_transformer(Img);
% Dapatkan pemetaan histogram equalization dari citra referensi
z = histogram_equalization_transformer(Img_referensi);
N = 256;
% Inverskan
for i = 1:N
    [~, imin] = min(abs(z - s(i)));
    s(i) = imin - 1;
end
% Ubah nilai pixel sesuai hasil invers
for idx = 1:numel(Img)
    Img(idx) = s(Img(idx) + 1);
end
end