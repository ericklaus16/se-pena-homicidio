:- discontiguous executar_opcao/1.

:- dynamic tipo_homicidio/1.
:- dynamic atenuante/1.
:- dynamic agravante/1.

:- consult('regras.pl').

% Menu principal
menu :- 
    write('1 - Calcular pena para homicidio'), nl,
    write('0 - Sair da aplicacao'), nl,
    read_line_to_string(user_input, Input), nl,
    atom_number(Input, Opt),
    executar_opcao(Opt), 
    nl.

% Define os dados do homicídio
set_dados(Tipo, Atenuante, Agravante) :- 
    retractall(tipo_homicidio(_)),
    retractall(atenuante(_)),
    retractall(agravante(_)),
    assertz(tipo_homicidio(Tipo)),
    assertz(atenuante(Atenuante)),
    assertz(agravante(Agravante)).

% Função para perguntar e ler os dados do usuário
perguntar_dado(Pergunta, Valor) :- 
    write(Pergunta), nl,
    read_line_to_string(user_input, Input), nl,
    atom_string(Valor, Input).

% Validar tipo de homicídio
validar_tipo(Tipo) :-
    member(Tipo, [simples, qualificado, culposo]).

% Validar atenuante
validar_atenuante(Atenuante) :-
    member(Atenuante, [nenhuma, violenta_emocao, valor_social_moral]).

% Validar agravante
validar_agravante(Agravante) :-
    member(Agravante, [nenhuma, idade_vitima_menor_14_ou_maior_60, negligencia_profissional, omissao_socorro, fuga_flagrante]).

% Lógica para executar as opções
executar_opcao(1) :- 
    perguntar_dado('Digite o tipo de homicidio (simples/qualificado/culposo): ', Tipo),
    (validar_tipo(Tipo) -> true; (write('Tipo invalido. Tente novamente.'), nl, executar_opcao(1))),
    
    perguntar_dado('Digite a circunstancia atenuante (nenhuma/violenta_emocao/valor_social_moral): ', Atenuante),
    (validar_atenuante(Atenuante) -> true; (write('Atenuante invalida. Tente novamente.'), nl, executar_opcao(1))),

    perguntar_dado('Digite a circunstancia agravante (nenhuma/idade_vitima_menor_14_ou_maior_60/negligencia_profissional/omissao_socorro/fuga_flagrante): ', Agravante),
    (validar_agravante(Agravante) -> true; (write('Agravante invalida. Tente novamente.'), nl, executar_opcao(1))),

    (Tipo == qualificado -> 
        perguntar_dado('Digite o motivo do homicidio qualificado (torpe/futil/veneno/fogo_explosivo/traicao_emboscada/para_outra_execucao): ', MotivoQualificado),
        (validar_motivo_qualificado(MotivoQualificado) -> true; (write('Motivo qualificado invalido. Tente novamente.'), nl, executar_opcao(1)))
    ;   true),
    
    set_dados(Tipo, Atenuante, Agravante),
    
    calcular_pena(Tipo, Atenuante, Agravante, (Min, Max)), % Recebe a tupla (Min, Max)
    
    % Exibe a pena calculada
    format('A pena calculada eh: ~2f a ~2f anos~n', [Min, Max]), 
    
    menu.

validar_motivo_qualificado(Motivo) :-
    member(Motivo, [torpe, futil, veneno, fogo_explosivo, traicao_emboscada, para_outra_execucao]).

executar_opcao(0) :- 
    write('Aplicacao finalizada!'), nl,
    halt.

executar_opcao(_) :- 
    write('Oops! Essa opcao eh invalida, tente novamente!'), nl,
    menu.

start :- menu.
