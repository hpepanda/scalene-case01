package hpsa.service;

import hpsa.persist.entity.Currency;
import hpsa.persist.repository.CurrencyRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CurrencyServiceImpl implements CurrencyService {

	@Autowired
	private CurrencyRepository currencyRepository;

	@Override
	public Iterable<Currency> findAll() {
		return currencyRepository.findAll();
	}

	@Override
	public Currency find(Currency currency) {
		return currencyRepository.findOne(currency.getCode());
	}

}
