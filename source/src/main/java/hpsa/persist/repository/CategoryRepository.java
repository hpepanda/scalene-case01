package hpsa.persist.repository;

import hpsa.persist.entity.Category;

import org.springframework.data.repository.PagingAndSortingRepository;

public interface CategoryRepository extends PagingAndSortingRepository<Category, Long> {

}
