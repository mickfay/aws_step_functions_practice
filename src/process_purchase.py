from random import randint
def process_purchase_handler(event, context):
    print("Hello World!")
    print("Event")
    print(event)
    print("Context")
    print(context)
    x = randint(1, 10)

    return { "value" : x }
    pass