package hpsa.persist.repository;

import hpsa.persist.entity.Currency;

import org.springframework.data.repository.PagingAndSortingRepository;

public interface CurrencyRepository extends PagingAndSortingRepository<Currency, String> {

}
