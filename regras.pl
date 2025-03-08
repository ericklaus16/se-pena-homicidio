% Fatos e regras para determinar o tipo de homicídio e a pena correspondente

% Tipos de homicídio e penas base
pena_base(simples, 6, 20).
pena_base(qualificado, 12, 30).
pena_base(culposo, 1, 3).

% Redução de pena para homicídio simples
reducao_pena(violenta_emocao, 1/6, 1/3).
reducao_pena(valor_social_moral, 1/6, 1/3).

% Aumento de pena para homicídio doloso
aumento_pena(idade_vitima_menor_14_ou_maior_60, 1/3).

% Aumento de pena para homicídio qualificado
aumento_pena(qualificado_torpe, 1/3).
aumento_pena(qualificado_futil, 1/3).
aumento_pena(qualificado_veneno, 1/3).
aumento_pena(qualificado_fogo_explosivo, 1/3).
aumento_pena(qualificado_traicao_emboscada, 1/3).
aumento_pena(qualificado_para_outra_execucao, 1/3).


% Aumento de pena para homicídio culposo
culposo_aumento_pena(negligencia_profissional, 1/3).
culposo_aumento_pena(omissao_socorro, 1/3).
culposo_aumento_pena(fuga_flagrante, 1/3).

% Exclusão de pena no homicídio culposo
exclusao_pena_culposo(Consequencias, Agente) :-
    Consequencias >= Agente, !, fail.  % Condição para exclusão da pena

% Cálculo da pena final
calcular_pena(Tipo, Atenuante, Agravante, (MinFinal, MaxFinal)) :-
    pena_base(Tipo, Min, Max),
    reduzir_pena(Min, Max, Atenuante, MinReduzido, MaxReduzido),
    aumentar_pena(Tipo, MinReduzido, MaxReduzido, Agravante, MinFinal, MaxFinal).

% Aplicação de Redução de Pena
reduzir_pena(Min, Max, Atenuante, MinFinal, MaxFinal) :-
    (   reducao_pena(Atenuante, RMin, RMax) ->
        MinFinal is Min - Min * RMin,
        MaxFinal is Max - Max * RMax
    ;   MinFinal = Min, MaxFinal = Max
    ).

% Aplicação de Aumento de Pena
aumentar_pena(Tipo, Min, Max, Agravante, MinFinal, MaxFinal) :-
    (   aumento_pena(Agravante, Aumento) -> 
        MinFinal is Min + Min * Aumento,
        MaxFinal is Max + Max * Aumento
    ;   % Verificar para homicídio doloso (simples ou qualificado)
        (   Tipo = simples ->
            MinFinal = Min, MaxFinal = Max
        ;   Tipo = qualificado ->
            MinFinal = Min, MaxFinal = Max
        ;   MinFinal = Min, MaxFinal = Max  % Caso padrão
        )
    ).