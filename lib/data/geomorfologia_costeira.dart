import '../models/geomorphic_classification.dart';

class GeomorfologiaCosteira {
  static final List<GeomorphClassification> tree = [
    GeomorphClassification(
      id: 'costeira',
      title: 'Geomorfologia Costeira',
      isRoot: true,
      children: [
        GeomorphClassification(
          title: 'Classificação de micro maré',
          desc: 'É a oscilação vertical da superficie do mar ou outra grande massa d\'água sobre a Terra, sendo caracterizada por uma oscilação de baixa amplitude. Esse fenômeno é causado primariamente pelas diferenças na atração gravitacional da Lua e, em menor extensão, do Sol sobre diversos pontos da Terra.',
          isPrimary: true,
          children: [
            GeomorphClassification(
              title: '0 metros'
            ),
            GeomorphClassification(
                title: '1 metro'
            ),
            GeomorphClassification(
                title: '2 metros'
            ),
          ],
        ),
        GeomorphClassification(
          title: 'Praia',
          isPrimary: true,
          children: [
            GeomorphClassification(
              title: 'Refletiva',
              desc: 'As praias refletivas caracterizam-se por apresentar estoque sedimentar emerso, alto gradiente na face de praia e uma zona de surfe estreita (geralmente não superior a 10 metros de extensão) ou inexistente. Elas ocorrem tipicamente em costas abrigadas sob condições de baixa energia, mas também podem se desenvolver em costas abertas de alta energia de ondas, desde que a composição sedimentar consista em grãos com tamanho superior ao de areia média (>0,25 mm), como as areias grossas de origem reliquiar descritas no litoral fluminense. Sob condições climáticas habituais, esses sistemas são relativamente estáveis e sua morfodinâmica discreta restringe-se à face de praia por meio da migração de cúspides praiais. No entanto, em decorrência da ausência de bancos submersos para dissipar a energia hidrodinâmica, as ondas tendem a arrebentar diretamente contra a face de praia. Sob tempestades severas, essa configuração induz uma resposta erosiva rápida e intensa. O forte refluxo do espraiamento e as correntes de retorno geradas pelas cúspides atuam de forma transversal, removendo e transportando sedimentos da praia em direção à zona de surfe e antepraia. Por essa razão, as praias refletivas mostram-se mais sensíveis e menos resilientes a eventos extremos de alta energia, sofrendo impactos morfológicos severos que frequentemente causam o recuo da berma e danos à base e à escarpa do sistema de dunas frontais.',
            ),
            GeomorphClassification(
              title: 'Intermediária',
              desc: 'As praias intermediárias caracterizam-se por apresentar elevada sensibilidade a mudanças na largura do perfil subaéreo e uma zona de surfe altamente dinâmica e bem desenvolvida, marcada pela presença de bancos arenosos e calhas submersas. Elas constituem sistemas caracterizados por uma ciclicidade contínua entre processos erosivos e de reincorporação de sedimentos, mediada pelo transporte de sedimentos através de células de circulação costeira e pela migração transversal de bancos arenosos em relação à linha de costa. Sob condições agradacionais de tempo bom (fases construtivas), as ondas induzem a migração desses bancos em direção à praia e a sua posterior soldagem e empilhamento vertical na base da face de praia, reconstituindo o estoque sedimentar emerso sob a forma de bermas. Em planta, esses sistemas exibem feições rítmicas características, como megacúspides na praia emersa que se desenvolvem alinhadas espacialmente com os bancos submersos transversais ou crescentes na zona de surfe. Em contrapartida, sob eventos de alta energia e tempestades, o padrão se inverte: as areias do perfil subaéreo são removidas e transportadas de volta para a antepraia, esculpindo calhas e bancos longitudinais ou transversais na zona submarina.',
            ),
            GeomorphClassification(
              title: 'Dissipativa',
              desc: 'As praias dissipativas caracterizam-se por apresentar sedimentação fina ou muito fina, o que determina um gradiente topográfico extremamente suave, frequentemente inferior a 1° tanto na face praial quanto na zona submarina. Esse sistema morfodinâmico possui uma zona de surfe bastante larga e bem desenvolvida, não raro superior a 200 metros em condições de tempestade, marcada pela presença de bancos e calhas submersas que não se destacam topograficamente e atuam dissipando a energia das ondas antes de atingirem a linha de costa. Sob condições climáticas habituais de tempo bom, a praia emersa permanece relativamente estável, de modo que a discreta morfodinâmica fica restrita à mobilidade dos bancos e calhas na zona de surfe. Diante de eventos de tempestade e ressacas extremas, as praias dissipativas exibem excelente resiliência e estabilidade em seu perfil subaéreo; a ampla zona de surfe amortece a arrebentação das ondas, ocorrendo primordialmente o deslocamento transversal de sedimentos para bancos na zona submarina, sem provocar alterações volumétricas ou morfológicas severas na porção emersa.',
            ),
          ],
        ),
        GeomorphClassification(
          title: 'Morfologia da Barreira Holocênica',
          isPrimary: true,
          children: [
            GeomorphClassification(
              title: 'Transgressiva',
              desc: 'Uma barreira costeira holocênica transgressiva caracteriza-se pela sua translação e migração contínua em direção ao continente ao longo de sua evolução geológica. Esse movimento é impulsionado majoritariamente por processos de transposição de ondas (overwash) em eventos de tempestades severas, nas quais ondas de alta energia superam o topo da barreira ou das dunas frontais, erodindo sedimentos da face de praia e projetando-os para o reverso na forma de leques (washover fans) ou terraços de transposição sobre a planície lagunar. Em subsuperfície, sua assinatura sedimentar típica, frequentemente mapeada por Radar de Penetração de Solo (GPR), revela refletores com mergulho inclinado em direção ao continente, caracterizando-se morfoestratigraficamente pelo empilhamento de depósitos praiais, eólicos ou de transposição sobrepostos a sedimentos lagunares ou estuarinos mais antigos, com eventual afloramento de turfas e lamas lagunares na face de praia atual sob condições erosivas.',
            ),
            GeomorphClassification(
              title: 'Regressiva',
              desc: 'Uma barreira costeira holocênica regressiva caracteriza-se por apresentar uma sucessão de cordões arenosos, cristas de praia ou cristas de dunas frontais que se tornaram feições reliquiares em função de um processo de progradação recorrente ao longo do tempo geológico, promovendo o avanço da linha de costa em direção ao mar e o consequente aumento da área continental. Esse padrão de empilhamento sedimentar em direção ao mar pode ocorrer sob condições de regressão forçada, impulsionada pelo abaixamento eustático do nível relativo do mar, ou sob condições de regressão normal, que ocorre quando a taxa de aporte sedimentar supera a taxa de criação de espaço de acomodação, mesmo sob gradual subida do nível marinho. Em subsuperfície, o imageamento por Radar de Penetração de Solo (GPR) revela refletores de pós-praia/estirâncio sobrepostos de forma progradacional a depósitos de antepraia superior, evidenciando a migração física do ambiente praial em direção ao oceano.',
            ),
            GeomorphClassification(
              title: 'Estacionária',
              desc: 'Uma barreira costeira holocênica estacionária caracteriza-se por sua relativa estabilidade posicional a médio e longo prazo, sem demonstrar tendências marcantes de recuo (retrogradação) ou avanço (progradação) da linha de costa. Esse sistema evolui primordialmente por meio de agradação vertical, processo governado pela contínua incorporação e empilhamento de sedimentos eólicos sobre a barreira, o que propicia o desenvolvimento expressivo de dunas frontais. Em subsuperfície, sua assinatura morfoestratigráfica típica (mapeada por GPR) revela o empilhamento de radarfácies eólicas diretamente sobre radarfácies praiais ou de pós-praia. Esse comportamento ocorre sob condições de lento aumento ou estabilidade do nível relativo do mar combinado a um moderado aporte sedimentar.',
            ),
          ],
        ),
        GeomorphClassification(
          title: 'Granulometria da Areia',
          isPrimary: true,
          children: [
            GeomorphClassification(
              title: 'Muito fina',
              desc: 'Caracterizados por grãos pequenos e extremamente leves, sendo facilmente transportáveis pelo vento. Possuem valores entre 0,0625 e 0,124 mm, correspondendo a valores entre 4 e 3 na escala Phi.',
            ),
            GeomorphClassification(
              title: 'Fina',
              desc: 'Possui valores em torno de 0,125 e 0,250 mm, correspondendo a valores entre 3 e 2 na escala Phi, geralmente associado a praias com menor energia e com tendências dissipativas.',
            ),
            GeomorphClassification(
              title: 'Média',
              desc: 'Caracterizada por grãos de tamanho intermediário, entre 0,250 e 0,500 mm, correspondendo a valores entre 2 e 1 na escala Phi.',
            ),
            GeomorphClassification(
              title: 'Grossa',
              desc: 'Geralmente associada a ambientes de alta energia, que facilitam o transporte de partículas maiores, seus grãos apresentam valores em torno de 0,500 e 1,000 mm, correspondendo a 1 e 0  na escala Phi.',
            ),
            GeomorphClassification(
              title: 'Muito grossa',
              desc: 'Definidos por grãos que apresentam valores entre 1,000 e 2,000 mm,  o que condiz entre 1 e 0 na escala Phi.',
            ),
          ],
        ),
        GeomorphClassification(
          title: 'Dunas',
          isPrimary: true,
          children: [
            GeomorphClassification(
              title: 'Livres',
              desc: 'As dunas livres caracterizam-se por se definirem livremente a partir dos processos de transporte e deposição de sedimentos pelo vento, ocorrendo na ausência de vegetação fixadora.',
              children: [
                GeomorphClassification(
                  title: 'Barcanas',
                  desc: 'As dunas barcanas são dunas livres simples caracterizadas por se desenvolverem na ausência de vegetação e sob condições de baixa disponibilidade de sedimentos associada a uma direção de vento constante com pouca ou nenhuma variabilidade. Morfologicamente, exibem um formato crescente típico, apresentando a porção central orientada em direção ao vento preferencial (barlavento) e os seus braços projetados a sotavento. Sendo altamente sensíveis a oscilações sazonais do vento, elas assumem configurações de simetria ou assimetria devido a flutuações direcionais e efeitos de rugosidade gerados pela vegetação ou por edificações próximas.',
                ),
                GeomorphClassification(
                  title: 'Barcanóides',
                  desc: 'As dunas barcanóides representam feições eólicas livres complexas resultantes da coalescência de dunas barcanas simples, gerando cristas eólicas transversais em resposta ao aumento da disponibilidade de sedimentos arenosos sob a ação de ventos de direção constante. No campo de dunas transgressivas de Cabo Frio e do Peró, essas feições desempenham um papel morfoestratigráfico fundamental na evolução das megadunas parabólicas que superam 20 metros de altitude; ali, a migração e a superposição dessas cristas transversais sobre depósitos eólicos longitudinais preexistentes promovem o empilhamento sistemático de diferentes estratos sedimentares.',
                ),
                GeomorphClassification(
                  title: 'Transversais',
                  desc: 'As dunas transversais são feições eólicas livres caracterizadas por se desenvolverem em regiões de alto aporte sedimentar sob a influência de ventos constantes que sopram em direção à costa. Diferenciando-se das dunas frontais por ocorrerem na ausência de vegetação fixadora, elas se organizam perpendicularmente à direção do vento dominante (e paralelas à linha de costa), formando cristas de areia contínuas que migram ativamente em direção ao continente.',
                ),
              ]
            ),
            GeomorphClassification(
              title: 'Ancoradas',
              desc: 'As dunas ancoradas caracterizam-se por apresentar seu desenvolvimento, morfologia e mobilidade diretamente condicionados por barreiras físicas, sendo subdivididas em dois grandes grupos: dunas ancoradas por vegetação e dunas ancoradas por obstáculos topográficos.',
              children: [
                GeomorphClassification(
                  title: 'Vegetação',
                  desc: 'As dunas ancoradas por vegetação têm seu desenvolvimento, morfologia e mobilidade diretamente condicionados pela presença de cobertura vegetal, que atua como obstáculo físico e agente fixador de sedimentos, destacando-se no litoral fluminense as dunas parabólicas e as nebkas.',
                  children: [
                    GeomorphClassification(
                      title: 'Frontais',
                      desc: 'As dunas frontais caracterizam-se como cristas de acumulação eólica formadas paralelamente à linha de costa no topo do pós-praia, cujo desenvolvimento é condicionado pela interação direta entre o suprimento de sedimentos da praia, a ação do vento e o papel fixador da vegetação pioneira de restinga. Elas são classificadas em incipientes (ou embrionárias), que se formam pela deposição eólica entre a vegetação pioneira, e estabilizadas, que se desenvolvem a partir das primeiras e apresentam maior altura, volume e colonização por vegetação lenhosa. O seu desenvolvimento volumétrico é governado pela classificação morfodinâmica da praia, sendo praias dissipativas e intermediárias as mais favoráveis, pela frequência e velocidade do vento, e pelo efeito de pista de vento, influenciado pela obliquidade do vento em relação à orientação da linha de costa.',
                    ),
                    GeomorphClassification(
                      title: 'Parabólicas',
                      desc: 'As dunas parabólicas caracterizam-se como acumulações eólicas em formato de "U", "V" ou semicírculo, cujo desenvolvimento é condicionado pela vegetação que ancora e estabiliza os seus “braços” laterais, enquanto o lóbulo deposicional central permanece móvel e migra ativamente a sotavento . Sua gênese está tipicamente associada ao desenvolvimento de cortes eólicos que desestabilizam e rompem a cobertura vegetal de superfícies arenosas preexistentes, canalizando os ventos em rajadas e gerando lóbulos de transporte sedimentar que migram em direção ao continente. Morfologicamente, dividem-se em feições simples e alongadas, denominadas dunas do tipo hairpin (ou grampo, marcadas por uma bacia de deflação central e uma alta razão de aspecto entre comprimento e largura, e dunas parabólicas complexas, que exibem múltiplos lóbulos de sedimentação e superfícies de reativação interna geradas por flutuações sazonais do vento.',
                    ),
                    GeomorphClassification(
                      title: 'Nebkas',
                      desc: 'As dunas nebkas são acumulações eólicas ancoradas que se desenvolvem a partir do aprisionamento e da fixação de sedimentos ao redor de moitas de vegetação pioneira de restinga. No litoral fluminense, especificamente na porção meridional da planície costeira de Cabo Frio e no leste da barreira da Massambaba, a gênese dessas feições está intimamente associada à espécie lenhosa focal Clusia fluminensis. Essa planta possui metabolismo ácido das crassuláceas (CAM), o que lhe confere alta tolerância ao estresse hídrico e facilita a sucessão ecológica ao abrigar espécies consorciadas como cactáceas e bromélias nessas ilhas de vegetação. Morfometricamente, as nebkas exibem alturas que variam de 2 a 3 metros (podendo atingir até 4 metros em acúmulos mais proeminentes), ajustando-se de forma direta à altura da copa da vegetação arbustiva local.',
                    ),
                  ]
                ),
              ]
            ),
          ],
        ),
      ],
    ),
  ];
}