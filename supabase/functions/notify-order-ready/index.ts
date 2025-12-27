import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import { Resend } from "https://esm.sh/resend@3.2.0"

serve(async (req) => {
  try {
    const { orderId } = await req.json()

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { data: order, error: orderError } = await supabaseClient
      .from('orders')
      .select('*, users(email, name)')
      .eq('id', orderId)
      .single()

    if (orderError || !order) throw new Error(`Commande #${orderId} introuvable`);

    const preference = order.notification_preference;
    const referenceName = order.reference_name || order.users?.name || 'Client';

    // --- LOGIQUE EMAIL (RESEND) ---
    if (preference === 'email' && order.users?.email) {
      const resend = new Resend(Deno.env.get('RESEND_API_KEY'));
      await resend.emails.send({
        from: 'Pizza Mania <onboarding@resend.dev>',
        to: [order.users.email],
        subject: 'Votre commande est prête ! 🍕',
        html: `<h2>Bonne nouvelle ${referenceName} !</h2><p>Votre commande est prête à être récupérée au camion Pizza Mania.</p>`
      });
      console.log(`✅ Email envoyé à ${order.users.email}`);
    }

    // --- LOGIQUE SMS (TWILIO) ---
    else if (preference === 'sms' && order.notification_phone) {
      const accountSid = Deno.env.get('TWILIO_ACCOUNT_SID');
      const authToken = Deno.env.get('TWILIO_AUTH_TOKEN');
      const fromNumber = Deno.env.get('TWILIO_PHONE_NUMBER');
      
      const toNumber = order.notification_phone; // Format attendu: +33612345678
      const message = `Pizza Mania : Bonne nouvelle ${referenceName}, votre commande est prête ! A tout de suite au camion. 🍕`;

      const response = await fetch(
        `https://api.twilio.com/2010-04-01/Accounts/${accountSid}/Messages.json`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic ' + btoa(`${accountSid}:${authToken}`),
          },
          body: new URLSearchParams({
            'To': toNumber,
            'From': fromNumber!,
            'Body': message,
          }),
        }
      );

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Erreur Twilio: ${errorData.message}`);
      }
      console.log(`✅ SMS envoyé à ${toNumber}`);
    }

    return new Response(JSON.stringify({ success: true }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    })

  } catch (error) {
    console.error('❌ Erreur:', error.message);
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { "Content-Type": "application/json" },
      status: 500,
    })
  }
})
