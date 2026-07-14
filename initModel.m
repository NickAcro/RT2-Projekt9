%System initialisieren
A = [-0.1055   -0.2651   0  -0.3535;
    -0.3535 -12.0521   1    0;
    1.3609  -29.8208   -3.8495    0;
    0      0       1       0];
B = [0;
    -0.7679;
    -25.2170;
    0];
C = eye(4); %nur um alle Zustände zu bekommen
D = zeros(4,1); %passen zu C

U0=20;

sys = ss(A,B,C,D);

%PID Werte automatisch bestimmen lassen

G_u = tf(sys(1));
Cpid_u = pidtune(G_u,'PID');
Cpid_u_P = Cpid_u.Kp;
Cpid_u_I = Cpid_u.Ki;
Cpid_u_D = Cpid_u.Kd;

G_alpha = tf(sys(2));
Cpid_a = pidtune(G_alpha,'PID');
Cpid_a_P = Cpid_a.Kp;
Cpid_a_I = Cpid_a.Ki;
Cpid_a_D = Cpid_a.Kd;

G_q = tf(sys(3));
Cpid_q = pidtune(G_q,'PID');
Cpid_q_P = Cpid_q.Kp;
Cpid_q_I = Cpid_q.Ki;
Cpid_q_D = Cpid_q.Kd;

G_theta = tf(sys(4));
Cpid_t = pidtune(G_theta,'PID');
Cpid_t_P = Cpid_t.Kp;
Cpid_t_I = Cpid_t.Ki;
Cpid_t_D = Cpid_t.Kd;

%Zustandsregler

p = [-2 -3 -5 -6];

K = place(A,B,p)

Acl = A - B*K;

eig(Acl);

N_u = inv([1 0 0 0]*inv(B*K-A)*B);

N_theta = inv([0 0 0 1]*inv(B*K-A)*B);

%LQ-Regler

Q = diag([1 1 1 10]);
R = 10;

K_lqr = lqr(A,B,Q,R)

N_lqr_u = -inv([1 0 0 0]*inv(A-B*K_lqr)*B)

N_lqr_theta = -inv([0 0 0 1]*inv(A-B*K_lqr)*B)

%Beobachter
observerPoles = [-15+8j -15-8j -4+1j -4-1j];

L = place(A',[1 0 0 0]',observerPoles)'