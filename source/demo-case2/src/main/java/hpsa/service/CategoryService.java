package hpsa.service;

import hpsa.persist.entity.Category;

public interface CategoryService {

	public Iterable<Category> findAll();

	public Category find(Category category);

}
