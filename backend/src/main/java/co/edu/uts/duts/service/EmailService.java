package co.edu.uts.duts.service;

import co.edu.uts.duts.util.EnvConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * EmailService: envio de correos transaccionales por SMTP.
 * Se configura con las variables SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASSWORD,
 * SMTP_FROM y SMTP_STARTTLS.
 */
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    public boolean estaConfigurado() {
        return EnvConfig.get("SMTP_HOST") != null && EnvConfig.get("SMTP_FROM") != null;
    }

    /** Envia un correo de texto plano. Devuelve true si el servidor SMTP lo acepto. */
    public boolean enviar(String destinatario, String asunto, String cuerpo) {
        if (!estaConfigurado()) {
            log.warn("SMTP no configurado (SMTP_HOST/SMTP_FROM): no se envio el correo '{}'.", asunto);
            return false;
        }
        Properties props = new Properties();
        props.put("mail.smtp.host", EnvConfig.get("SMTP_HOST"));
        props.put("mail.smtp.port", EnvConfig.get("SMTP_PORT", "587"));
        props.put("mail.smtp.starttls.enable", String.valueOf(EnvConfig.getBoolean("SMTP_STARTTLS", true)));
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");

        final String user = EnvConfig.get("SMTP_USER");
        final String pass = EnvConfig.get("SMTP_PASSWORD");
        Session session;
        if (user != null) {
            props.put("mail.smtp.auth", "true");
            session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(user, pass);
                }
            });
        } else {
            session = Session.getInstance(props);
        }

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(EnvConfig.get("SMTP_FROM")));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario, true));
            msg.setSubject(asunto, "UTF-8");
            msg.setText(cuerpo, "UTF-8");
            Transport.send(msg);
            return true;
        } catch (MessagingException e) {
            log.error("Error al enviar correo '{}': {}", asunto, e.getMessage());
            return false;
        }
    }
}
