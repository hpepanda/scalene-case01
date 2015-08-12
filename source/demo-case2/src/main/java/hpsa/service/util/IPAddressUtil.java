package hpsa.service.util;

import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Component;

@Component
public class IPAddressUtil {

	private static final Logger logger = LoggerFactory.getLogger(IPAddressUtil.class);

	@Cacheable(value = "localIp")
	public String getLocalIp() {
		try {
			Enumeration<NetworkInterface> interfaces;
			interfaces = NetworkInterface.getNetworkInterfaces();
			while (interfaces.hasMoreElements()) {
				NetworkInterface i = (NetworkInterface) interfaces.nextElement();
				for (Enumeration<InetAddress> en2 = i.getInetAddresses(); en2.hasMoreElements();) {
					InetAddress addr = (InetAddress) en2.nextElement();
					if (!addr.isLoopbackAddress()) {
						if (addr instanceof Inet4Address) {
							return addr.toString();
						}
						if (addr instanceof Inet6Address) {
							continue;
						}
					}
				}
			}
		} catch (SocketException e) {
			logger.error(e.toString(), e);
		}
		return "unknown";
	}

}
