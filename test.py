def remove_nth_character(string, n):
    char_list = list(string)
    char_list.pop(n)
    return "".join(char_list)

print(remove_nth_character("Olushola", 3))
