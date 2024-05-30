#  Дипломная работа по профессии «Системный администратор»

Содержание
==========

* [Задание](#Задание)
* [Порядок проведения работы](#Порядок-проведения-работы)
* [Фиксация результатов](#Фиксация-результатов-выполнения-пунктов-задания)
    * [Сайт](#Сайт)
    * [Мониторинг](#Мониторинг)
    * [Логи](#Логи)
    * [Сеть](#Сеть)
    * [Резервное копирование](#Резервное-копирование)

---------
## Задание

[Задание](https://github.com/netology-code/sys-diplom/tree/diplom-zabbix?tab=readme-ov-file#Сайт).


## Порядок проведения работы

### Согласно требованиям задания дипломной работы, созданы следующие VM:

 - vm-ansible (ubuntu-2204-lts)
 - vm-ELK (ubuntu-2204-lts)
 - vm-zabbix (ubuntu-2204-lts)
 - vm-proxy1 (ubuntu-2204-lts)
 - vm-proxy2 (ubuntu-2204-lts)

   Также развернут Application Load Balancer для распределения HTTP-запросов между Web-серверами vm-proxy1/vm-proxy2.

   Виртуальные машины развёрнуты на YandexCloud с помощью Terraform сценария, на этапе 
установки на машины устанавливается ssh pulic key для дальнейшего доступа по ssh ключу.
В сценарии Terraform реализованы разные зоны для vm-proxy1, vm-proxy2, разные подсети, 
а также группы безопасности для ограничения доступа извне. Также сценарий включает 
регулярное бекапирование по расписанию (snapshot disk) согласно заданию.

* private key для доступа ssh на vm-ansible приложен в перечне файлов GitHub (директория privatekey).
* Для доступа на vm-ansible по ssh используется пользователь andy.

### Виртуальные машины имеют следующий состав и назначение:

 1. vm-ansible - на этой машине установен ansible для автоконфигурирования остальных машин.
 2. vm-ELK  - на этой машине установлен docker/Compose на котором в свою очередь установлены 
    контейнеры elasticsearch и kibana.
 3. vm-zabbix - на этой машине установлен docker/Compose на котором в свою очередь установлен
    zabbix server. 
 4. vm-proxy1 и vm-proxy2 - на этих машинах установлены nginx Web-сервера, zabbiz agent, 
    docker/Compose на котором в свою очередь установлен filebeat. 

   Установка компонент 2-4, а также их конфигурационных файлов осуществляется через ansible playbook 
для трёх разных групп хостов: web, ELK, ZabbixSRV. 

### Последовательность разворачивания VMs:

 1. На рабочей машине запускается сценарий Terraform:
   ```
      terraform validate  (статус OK!)
      terraform plan      (проверка dry install)
      terraform apply     (установка)
   ``` 
    При этом в консоли указывается Token для доступа к YandexCloud. 

 2. После того как будут установлены все машины и App Load Balancer, 
    копируем приватный ключ с рабочей машины на машину vm-ansible. 

 3. На vm-ansible устанавливаем ansible:

	``` apt install ansible ```

 4. Копируем на машину vm-ansible в домашнюю папку пользователя проект ansible следующего содержания:

    - файл с перечнем хостов: inventory
    - файл конфигурации ansible: ansible.cfg
    - файл playbook: ansible_roles_proxy.yml
    - файл playbook: ansible_roles_elk.yml
    - файл playbook: ansible_roles_zabbix.yml
    - роли:
	* docker_install
	* elastic_kibana_install
	* fb_install
	* nginx
	* zabbix-agent
	* zabbix_srv_install

 
 5. Запускаем playbook поочерёдности: 

    1) Устанавливаем nginx, docker/Compose,filebeat,zabbix agent и соответсвуюшие конфигурации

         ` ansible-playbook ansible_roles_proxy.yml -i inventory `

    2) Устанавливаем elasticsearch,kibana,docker/Compose и соответсвуюшие конфигурации

         ` ansible-playbook ansible_roles_elk.yml -i inventory `
 
    3) Устанавливаем zabbix server,docker и соответсвуюшие конфигурации

         ` ansible-playbook ansible_roles_zabbix.yml -i inventory ` 

 6. Настраиваем через Web-интерфейс index (filebeat-*) для поиска событий от filebeat в Kibana
 7. Настраиваем через Web-интерфейс zabbix server: Hosts, Template, Dashboard. 

----

## Фиксация результатов выполнения пунктов задания 

* Учётные данные для входа в Веб-интерфейс  Zabbix: Admin / zabbix
* Учётные данные для входа в Веб-интерфейс Kibana : elastic / test
* Вход на vm-ansible по ssh по ключу (директория privatkey)

### Сайт




### Мониторинг

### Логи

### Сеть

### Резервное



*Две*

![Commit Site](https://github.com/AndrewZnamenskiy/Diplom/blob/main/img/Sitep1.png)



