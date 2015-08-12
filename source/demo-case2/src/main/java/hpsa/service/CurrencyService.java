package hpsa.service;

import hpsa.persist.entity.Currency;

public interface CurrencyService {

	public Iterable<Currency> findAll();

	public Currency find(Currency currency);

}
