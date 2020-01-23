

Map<C, List<M>> categorized<C, M>(
    List<C> allCategories, List<M> models, C getterCategory(M model),
    ) {

  final categories = allCategories.where((category) {
    return models.map(getterCategory)
        .any((modelCategory) => category == modelCategory);
  });
  return Map.fromIterable(categories,
    key: (category) {
      return category;
    },  value: (category) {
      return models.where((model) => getterCategory(model) == category).toList();
    },
  );
}