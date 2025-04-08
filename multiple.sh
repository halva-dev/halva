#!/bin/bash

RED='\033[0;31M'
GREEN='\033[0;32M'
YELLOW='\033[0;33M'
BLUE='\033[0;34M'
MAGENTA='\033[0;35M'
CYAN='\033[0;36M'
NC='\033[0M' #RESET COLOR

# Check if curl is installed and install it if not
if ! command -v curl &> /dev/null; then
    sudo apt update
    sudo apt install curl -y
fi
sleep 1

# Show logo
curl -s https://raw.githubusercontent.com/halva-dev/halva/refs/heads/main/logo_script.sh | bash

# Menu
echo -e "${YELLOW}Выберите действие:${NC}"
echo -e "${CYAN}1) Установить ноду${NC}"
echo -e "${CYAN}2) Проверить статус ноды${NC}"
echo -e "${CYAN}3) Удалить ноду${NC}"

echo -e "${YELLOW}Введите номер:${NC} "
read choice


case $choice in
    1)
        echo -e "${BLUE}Вы выбрали установку ноды.${NC}"

        # Update and install dependencies
        sudo apt update && sudo apt upgrade -y

        rm -f ~/install.sh ~/update.sh ~/start.sh

        # Download client
        echo -e "${BLUE}Скачиваем клиент...${NC}"
        wget https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/install.sh
        source ./install.sh

        # Update client
        echo -e "${BLUE}Обновляем клиент...${NC}"
        wget https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/update.sh
        source ./update.sh

        # Moove to client directory
        cd
        cd multipleforlinux

        # Start client
        echo -e "${BLUE}Заупускаем клиент...${NC}"
        wget https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/start.sh
        source ./start.sh

        #Enter ID and PIN
        echo -e "${YELLOW}Введите ID:${NC}"
        read IDENTIFIER
        echo -e "${YELLOW}Введите PIN:${NC}"
        read PIN

        # Bind ID and PIN
        echo -e "${BLUE}Привязываем ID: $IDENTIFIER и PIN: $PIN...${NC}"
        multiple-cli bind --bandwidth-download 100 --identifier $IDENTIFIER --pin $PIN --storage 200 --bandwidth-upload 100

        # Final message
        echo -e "${MAGENTA}/////////////////////////////////////////////////////////////////////${NC}"
        echo -e "${MAGENTA}///// ${GREEN}Установка завершена!${NC}"
        echo -e "${MAGENTA}///// ${GREEN}24% Halving мэнс${NC}"
        echo -e "${MAGENTA}///// ${CYAN}Наш тг: https://t.me/halvingMens${NC}"
        echo -e "${MAGENTA}/////////////////////////////////////////////////////////////////////${NC}"
        sleep 2
        cd && cd ~/multipleforlinux && ./multiple-cli status
        ;;
    2)
        # Check logs
        echo -e "${BLUE}Вы выбрали проверку статуса ноды.${NC}"
        cd && cd ~/multipleforlinux && ./multiple-cli status
        ;;
    3)
        # Remove client
        echo -e "${BLUE}Вы выбрали удаление ноды.${NC}"

        # Kill node process
        echo -e "${BLUE}Завершаем процесс ноды...${NC}"
        pkill -f multiple-node

        # Delete files
        cd ~
        sudo rm -rf multipleforlinux

        # Final message
        echo -e "${MAGENTA}/////////////////////////////////////////////////////////////////////${NC}"
        echo -e "${MAGENTA}///// ${GREEN}Удаление завершено!${NC}"
        echo -e "${MAGENTA}///// ${GREEN}24% Halving мэнс${NC}"
        echo -e "${MAGENTA}///// ${CYAN}Наш тг: https://t.me/halvingMens${NC}"
        echo -e "${MAGENTA}/////////////////////////////////////////////////////////////////////${NC}"
        ;;

    *)
        # Invalid option
        echo -e "${RED}Неверный выбор. Пожалуйста, выберите 1, 2 или 3.${NC}"
        ;;
esac
