package hpsa.service;

import hpsa.persist.entity.Category;
import hpsa.persist.repository.CategoryRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CategoryServiceImpl implements CategoryService {

	@Autowired
	private CategoryRepository categoryRepository;

	@Override
	public Iterable<Category> findAll() {
		return categoryRepository.findAll();
	}

	@Override
	public Category find(Category category) {
		return categoryRepository.findOne(category.getId());
	}

}
