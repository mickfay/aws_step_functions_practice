def lambda_handler(event, context):
    print("It's lambda 2 time!")
    print("Event NEW")
    print(f"The given value was {event['value']}")
    print("Context")
    print(context)
    pass