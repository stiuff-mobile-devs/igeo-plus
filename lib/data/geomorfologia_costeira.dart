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
            ),
            GeomorphClassification(
              title: 'Intermediária',
            ),
            GeomorphClassification(
              title: 'Dissipativa',
            ),
          ],
        ),
        GeomorphClassification(
          title: 'Morfologia da Barreira Holocênica',
          isPrimary: true,
          children: [
            GeomorphClassification(
              title: 'Transgressiva',
            ),
            GeomorphClassification(
              title: 'Regressiva',
            ),
            GeomorphClassification(
              title: 'Estacionária',
            ),
          ],
        ),
        GeomorphClassification(
          title: 'Granulometria da Areia',
          isPrimary: true,
          children: [
            GeomorphClassification(
              title: 'Muito fina',
            ),
            GeomorphClassification(
              title: 'Fina',
            ),
            GeomorphClassification(
              title: 'Média',
            ),
            GeomorphClassification(
              title: 'Grossa',
            ),
            GeomorphClassification(
              title: 'Muito grossa',
            ),
          ],
        ),
        GeomorphClassification(
          title: 'Dunas',
          isPrimary: true,
          children: [
            GeomorphClassification(
              title: 'Livres',
              children: [
                GeomorphClassification(
                  title: 'Darcanas',
                ),
                GeomorphClassification(
                  title: 'Barcanoides',
                ),
                GeomorphClassification(
                  title: 'Transversais',
                ),
              ]
            ),
            GeomorphClassification(
              title: 'Ancoradas',
              children: [
                GeomorphClassification(
                  title: 'Vegetação',
                  children: [
                    GeomorphClassification(
                      title: 'Frontais',
                    ),
                    GeomorphClassification(
                      title: 'Parabólicas',
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