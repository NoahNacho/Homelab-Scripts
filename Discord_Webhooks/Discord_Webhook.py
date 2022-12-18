from discord_webhook import DiscordWebhook,DiscordEmbed


webhook = DiscordWebhook(url='', rate_limit_retry=True)

embed = DiscordEmbed(title='message title', description="message", color='03b2f8')
webhook.add_embed(embed)

response = webhook.execute()
